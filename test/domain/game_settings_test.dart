import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/domain/entities/game_config.dart';
import 'package:orchom/domain/entities/game_settings.dart';
import 'package:orchom/domain/entities/quick_score_button.dart';
import 'package:orchom/domain/enums/app_theme_mode.dart';
import 'package:orchom/domain/enums/starter_mode.dart';

void main() {
  group('GameSettings', () {
    test('defaultSettings contains Kmalt, Frach wahdou and Ghalta', () {
      final settings = GameSettings.defaultSettings();
      final buttons = settings.quickScoreButtons;

      expect(buttons, hasLength(3));
      expect(buttons[0].label, 'Kmalt');
      expect(buttons[0].value, -10);
      expect(buttons[1].label, 'Frach wahdou');
      expect(buttons[1].value, -50);
      expect(buttons[2].label, 'Ghalta');
      expect(buttons[2].value, 50);
    });

    test('defaultSettings has defaultGhaltaPenalty = 50', () {
      final settings = GameSettings.defaultSettings();
      expect(settings.defaultGhaltaPenalty, 50);
    });

    test('defaultSettings has defaultStarterMode = rotation', () {
      final settings = GameSettings.defaultSettings();
      expect(settings.defaultStarterMode, StarterMode.rotation);
    });

    test('defaultSettings has appThemeMode = light', () {
      final settings = GameSettings.defaultSettings();
      expect(settings.appThemeMode, AppThemeMode.light);
    });

    test('toJson and fromJson roundtrip preserves all fields', () {
      final settings = GameSettings.defaultSettings();
      final json = settings.toJson();
      final restored = GameSettings.fromJson(json);

      expect(restored.quickScoreButtons, hasLength(3));
      expect(restored.quickScoreButtons[0].label, 'Kmalt');
      expect(restored.quickScoreButtons[2].label, 'Ghalta');
      expect(restored.defaultGhaltaPenalty, 50);
      expect(restored.defaultStarterMode, StarterMode.rotation);
      expect(restored.appThemeMode, AppThemeMode.light);
    });

    test('toJson and fromJson roundtrip preserves appThemeMode light', () {
      final settings = GameSettings.defaultSettings().copyWith(
        appThemeMode: AppThemeMode.light,
      );
      final json = settings.toJson();
      final restored = GameSettings.fromJson(json);

      expect(restored.appThemeMode, AppThemeMode.light);
    });

    test('toJson and fromJson roundtrip preserves appThemeMode system', () {
      final settings = GameSettings.defaultSettings().copyWith(
        appThemeMode: AppThemeMode.system,
      );
      final json = settings.toJson();
      final restored = GameSettings.fromJson(json);

      expect(restored.appThemeMode, AppThemeMode.system);
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

    test('fromJson uses light when appThemeMode absent', () {
      final json = {
        'quickScoreButtons': [
          {'id': 'qs_1', 'label': 'Test', 'value': 10},
        ],
        'defaultGhaltaPenalty': 50,
        'defaultStarterMode': 'rotation',
      };

      final restored = GameSettings.fromJson(json);
      expect(restored.appThemeMode, AppThemeMode.light);
    });

    test('fromJson restores appThemeMode correctly when present', () {
      final json = {
        'quickScoreButtons': [
          {'id': 'qs_1', 'label': 'Test', 'value': 10},
        ],
        'defaultGhaltaPenalty': 50,
        'defaultStarterMode': 'rotation',
        'appThemeMode': 'light',
      };

      final restored = GameSettings.fromJson(json);
      expect(restored.appThemeMode, AppThemeMode.light);
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

    test('copyWith replaces appThemeMode', () {
      final settings = GameSettings.defaultSettings();
      final custom = settings.copyWith(appThemeMode: AppThemeMode.light);
      expect(custom.appThemeMode, AppThemeMode.light);
      expect(custom.defaultGhaltaPenalty, 50);
    });

    test('copyWith keeps appThemeMode when not specified', () {
      final settings = GameSettings.defaultSettings().copyWith(
        appThemeMode: AppThemeMode.light,
      );
      final custom = settings.copyWith();
      expect(custom.appThemeMode, AppThemeMode.light);
    });

    test('toJson and fromJson preserves quick buttons with soundId', () {
      final buttons = [
        QuickScoreButton(
          id: 'qs_1',
          label: 'Test',
          value: 10,
          soundId: 'sound_01',
        ),
      ];
      final settings = GameSettings.defaultSettings().copyWith(
        quickScoreButtons: buttons,
      );
      final json = settings.toJson();
      final restored = GameSettings.fromJson(json);

      expect(restored.quickScoreButtons, hasLength(1));
      expect(restored.quickScoreButtons[0].soundId, 'sound_01');
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

      expect(config.quickScoreButtons, hasLength(3));
      expect(config.quickScoreButtons[0].label, 'Kmalt');
      expect(config.quickScoreButtons[2].label, 'Ghalta');
    });
  });
}
