import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/domain/entities/game_config.dart';
import 'package:orchom/domain/entities/game_settings.dart';
import 'package:orchom/domain/entities/quick_score_button.dart';
import 'package:orchom/domain/enums/starter_mode.dart';

void main() {
  group('GameSettings', () {
    test('defaultSettings contains -10, -20, -100, +Ghalta', () {
      final settings = GameSettings.defaultSettings();
      final buttons = settings.quickScoreButtons;

      expect(buttons, hasLength(4));
      expect(buttons[0].label, '-10');
      expect(buttons[0].value, -10);
      expect(buttons[1].label, '-20');
      expect(buttons[1].value, -20);
      expect(buttons[2].label, '-100');
      expect(buttons[2].value, -100);
      expect(buttons[3].label, '+Ghalta');
      expect(buttons[3].value, 50);
    });

    test('defaultSettings has defaultGhaltaPenalty = 50', () {
      final settings = GameSettings.defaultSettings();
      expect(settings.defaultGhaltaPenalty, 50);
    });

    test('defaultSettings has defaultStarterMode = rotation', () {
      final settings = GameSettings.defaultSettings();
      expect(settings.defaultStarterMode, StarterMode.rotation);
    });

    test('toJson and fromJson roundtrip preserves all fields', () {
      final settings = GameSettings.defaultSettings();
      final json = settings.toJson();
      final restored = GameSettings.fromJson(json);

      expect(restored.quickScoreButtons, hasLength(4));
      expect(restored.quickScoreButtons[0].label, '-10');
      expect(restored.quickScoreButtons[3].label, '+Ghalta');
      expect(restored.defaultGhaltaPenalty, 50);
      expect(restored.defaultStarterMode, StarterMode.rotation);
    });

    test('fromJson compat without defaultGhaltaPenalty uses 50', () {
      final json = {
        'quickScoreButtons': [
          {'id': 'qs_1', 'label': 'Test', 'value': 10},
        ],
        'defaultStarterMode': 'rotation',
      };

      final restored = GameSettings.fromJson(json);
      expect(restored.defaultGhaltaPenalty, 50);
      expect(restored.defaultStarterMode, StarterMode.rotation);
    });

    test('fromJson compat without defaultStarterMode uses rotation', () {
      final json = {
        'quickScoreButtons': [
          {'id': 'qs_1', 'label': 'Test', 'value': 10},
        ],
        'defaultGhaltaPenalty': 100,
      };

      final restored = GameSettings.fromJson(json);
      expect(restored.defaultGhaltaPenalty, 100);
      expect(restored.defaultStarterMode, StarterMode.rotation);
    });

    test('fromJson compat without both new fields uses defaults', () {
      final json = {
        'quickScoreButtons': [
          {'id': 'qs_1', 'label': 'Test', 'value': 10},
        ],
      };

      final restored = GameSettings.fromJson(json);
      expect(restored.defaultGhaltaPenalty, 50);
      expect(restored.defaultStarterMode, StarterMode.rotation);
    });

    test('copyWith replaces quickScoreButtons', () {
      final settings = GameSettings.defaultSettings();
      final custom = settings.copyWith(
        quickScoreButtons: [
          QuickScoreButton(id: 'qs_custom', label: 'Test', value: 99),
        ],
      );

      expect(custom.quickScoreButtons, hasLength(1));
      expect(custom.quickScoreButtons[0].label, 'Test');
    });

    test('copyWith replaces defaultGhaltaPenalty', () {
      final settings = GameSettings.defaultSettings();
      final custom = settings.copyWith(defaultGhaltaPenalty: 200);
      expect(custom.defaultGhaltaPenalty, 200);
      expect(custom.defaultStarterMode, StarterMode.rotation);
    });

    test('copyWith replaces defaultStarterMode', () {
      final settings = GameSettings.defaultSettings();
      final custom = settings.copyWith(defaultStarterMode: StarterMode.random);
      expect(custom.defaultStarterMode, StarterMode.random);
      expect(custom.defaultGhaltaPenalty, 50);
    });
  });

  group('GameConfig quickScoreButtons', () {
    test('toJson and fromJson roundtrip preserves quickScoreButtons', () {
      final buttons = [
        QuickScoreButton(id: 'qs_1', label: 'Custom', value: 42),
      ];
      final config = GameConfig(
        targetScore: 100,
        ghaltaPenalty: 50,
        playerCount: 2,
        quickScoreButtons: buttons,
      );

      final json = config.toJson();
      final restored = GameConfig.fromJson(json);

      expect(restored.quickScoreButtons, hasLength(1));
      expect(restored.quickScoreButtons[0].label, 'Custom');
      expect(restored.quickScoreButtons[0].value, 42);
    });

    test('fromJson restores default buttons when key is missing', () {
      final json = {
        'targetScore': 100,
        'ghaltaPenalty': 50,
        'playerCount': 2,
        'starterMode': 'rotation',
      };

      final config = GameConfig.fromJson(json);

      expect(config.quickScoreButtons, hasLength(4));
      expect(config.quickScoreButtons[0].label, '-10');
      expect(config.quickScoreButtons[3].label, '+Ghalta');
    });
  });
}
