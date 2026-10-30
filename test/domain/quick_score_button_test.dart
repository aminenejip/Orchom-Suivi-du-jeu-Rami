import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/domain/entities/quick_score_button.dart';

void main() {
  group('QuickScoreButton', () {
    test('toJson and fromJson roundtrip', () {
      final button = QuickScoreButton(id: 'qs_1', label: '-10', value: -10);
      final json = button.toJson();
      final restored = QuickScoreButton.fromJson(json);

      expect(restored.id, 'qs_1');
      expect(restored.label, '-10');
      expect(restored.value, -10);
    });

    test('defaultButtons contains the correct buttons', () {
      final defaults = QuickScoreButton.defaultButtons;

      expect(defaults, hasLength(3));
      expect(defaults[0].label, 'Kmalt');
      expect(defaults[0].value, -10);
      expect(defaults[1].label, 'Frach wahdou');
      expect(defaults[1].value, -50);
      expect(defaults[2].label, 'Ghalta');
      expect(defaults[2].value, 50);
    });

    test('copyWith creates a modified copy', () {
      final button = QuickScoreButton(id: 'qs_1', label: '-10', value: -10);
      final modified = button.copyWith(label: '-20', value: -20);

      expect(modified.id, 'qs_1');
      expect(modified.label, '-20');
      expect(modified.value, -20);
    });

    test('toJson saves soundId', () {
      final button = QuickScoreButton(
        id: 'qs_1',
        label: 'Test',
        value: 10,
        soundId: 'sound_01',
      );
      final json = button.toJson();
      expect(json['soundId'], 'sound_01');
    });

    test('fromJson restores soundId', () {
      final json = {
        'id': 'qs_1',
        'label': 'Test',
        'value': 10,
        'soundId': 'sound_02',
      };
      final restored = QuickScoreButton.fromJson(json);
      expect(restored.soundId, 'sound_02');
    });

    test('fromJson uses none when soundId absent', () {
      final json = {'id': 'qs_1', 'label': 'Test', 'value': 10};
      final restored = QuickScoreButton.fromJson(json);
      expect(restored.soundId, 'none');
    });

    test('copyWith modifies soundId', () {
      final button = QuickScoreButton(
        id: 'qs_1',
        label: 'Test',
        value: 10,
        soundId: 'none',
      );
      final modified = button.copyWith(soundId: 'sound_01');
      expect(modified.soundId, 'sound_01');
      expect(modified.id, 'qs_1');
    });

    test('default soundId is none', () {
      final button = QuickScoreButton(id: 'qs_1', label: 'Test', value: 10);
      expect(button.soundId, 'none');
    });
  });
}
