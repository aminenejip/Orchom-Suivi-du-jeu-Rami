import 'package:flutter_test/flutter_test.dart';
import 'package:orchom/domain/entities/quick_button_sound_option.dart';

void main() {
  group('QuickButtonSoundOption', () {
    test('availableSounds contains none', () {
      final none = QuickButtonSoundOption.availableSounds.firstWhere(
        (s) => s.id == 'none',
      );
      expect(none.label, 'Aucun son');
      expect(none.assetPath, isNull);
    });

    test('availableSounds contains at least one sound with non-null assetPath',
        () {
      final withSound =
          QuickButtonSoundOption.availableSounds.where((s) => s.assetPath != null);
      expect(withSound.isNotEmpty, isTrue);
    });

    test('findById returns correct option', () {
      final sound = QuickButtonSoundOption.findById('sound_01');
      expect(sound, isNotNull);
      expect(sound!.id, 'sound_01');
      expect(sound.label, 'Son 01');
      expect(sound.assetPath, 'sounds/tunisian_meme_01_6s.mp3');
    });

    test('findById returns null for unknown id', () {
      expect(QuickButtonSoundOption.findById('unknown'), isNull);
    });

    test('findById returns none option', () {
      final none = QuickButtonSoundOption.findById('none');
      expect(none, isNotNull);
      expect(none!.assetPath, isNull);
    });
  });
}
