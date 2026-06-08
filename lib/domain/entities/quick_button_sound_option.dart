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
      label: 'Yar7am waldin waldik',
      assetPath: 'sounds/9-yar7am-waldin-waldik.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_02',
      label: 'Bech narja3 lechrab',
      assetPath: 'sounds/bech-narja3-lechrab.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_03',
      label: 'Cat laugh',
      assetPath: 'sounds/cat-laugh-meme-1.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_04',
      label: 'Chichaaaaaa',
      assetPath: 'sounds/chichaaaaaa.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_05',
      label: 'Dry fart',
      assetPath: 'sounds/dry-fart.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_06',
      label: 'Fahhhhhhhhhhh',
      assetPath: 'sounds/fahhhhhhh.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_07',
      label: 'Fat7i',
      assetPath: 'sounds/fat7i.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_08',
      label: 'Ibrahimi irahamni',
      assetPath: 'sounds/ibrahimi irahamni.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_09',
      label: 'Le ailha il lah',
      assetPath: 'sounds/le ailha il lah.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_10',
      label: 'Creditos finales',
      assetPath: 'sounds/meme-de-creditos-finales.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_11',
      label: 'No no wait wait',
      assetPath: 'sounds/no-no-wait-wait.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_12',
      label: 'Oh no meme',
      assetPath: 'sounds/oh-no-meme-2020_hX2n56J.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_13',
      label: 'Sali 3annebi',
      assetPath: 'sounds/sali-3annebi-w-yezi-mel-bleda.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_14',
      label: 'Sbh lkhyr y wldy',
      assetPath: 'sounds/sbh-lkhyr-y-wldy.mp3',
    ),
    QuickButtonSoundOption(
      id: 'sound_15',
      label: 'Tetmiko 3liya',
      assetPath: 'sounds/tetmniko 3liya.mp3',
    ),
  ];

  static QuickButtonSoundOption? findById(String id) {
    for (final sound in availableSounds) {
      if (sound.id == id) return sound;
    }
    return null;
  }
}
