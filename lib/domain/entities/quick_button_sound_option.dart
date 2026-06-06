class QuickButtonSoundOption {
  final String id;
  final String label;
  final String? assetPath;

  const QuickButtonSoundOption({
    required this.id,
    required this.label,
    this.assetPath,
  });

  static const List<QuickButtonSoundOption> availableSounds = [
    QuickButtonSoundOption(id: 'none', label: 'Aucun son'),
    QuickButtonSoundOption(
      id: 'sound_01',
      label: 'Son 01',
      assetPath: 'sounds/tunisian_meme_01_6s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_02',
      label: 'Son 02',
      assetPath: 'sounds/tunisian_meme_02_4s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_03',
      label: 'Son 03',
      assetPath: 'sounds/tunisian_meme_03_3s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_04',
      label: 'Son 04',
      assetPath: 'sounds/are_you_serious_3s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_05',
      label: 'Son 05',
      assetPath: 'sounds/tunisian_meme_04_2s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_06',
      label: 'Son 06',
      assetPath: 'sounds/tunisian_meme_05_4s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_07',
      label: 'Son 07',
      assetPath: 'sounds/tunisian_meme_06_2s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_08',
      label: 'Son 08',
      assetPath: 'sounds/tunisian_meme_07_long_22s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_09',
      label: 'Son 09',
      assetPath: 'sounds/tunisian_meme_08_long_10s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_10',
      label: 'Son 10',
      assetPath: 'sounds/tunisian_meme_09_2s.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_11',
      label: 'Son 11',
      assetPath: 'sounds/tunisian_meme_10_2s.mp3',
    ),
  ];

  static QuickButtonSoundOption? findById(String id) {
    for (final sound in availableSounds) {
      if (sound.id == id) return sound;
    }
    return null;
  }
}
