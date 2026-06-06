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

    test('defaultButtons contains the correct 4 buttons', () {
      final defaults = QuickScoreButton.defaultButtons;

      expect(defaults, hasLength(4));
      expect(defaults[0].label, '-10');
      expect(defaults[0].value, -10);
      expect(defaults[1].label, '-20');
      expect(defaults[1].value, -20);
      expect(defaults[2].label, '-100');
      expect(defaults[2].value, -100);
      expect(defaults[3].label, '+Ghalta');
      expect(defaults[3].value, 50);
    });

    test('copyWith creates a modified copy', () {
      final button = QuickScoreButton(id: 'qs_1', label: '-10', value: -10);
      final modified = button.copyWith(label: '-20', value: -20);

      expect(modified.id, 'qs_1');
      expect(modified.label, '-20');
      expect(modified.value, -20);
    });
  });
}
