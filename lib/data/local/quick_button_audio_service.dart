import 'package:audioplayers/audioplayers.dart';
import '../../domain/entities/quick_button_sound_option.dart';

class QuickButtonAudioService {
  AudioPlayer? _player;

  Future<void> playBySoundId(String soundId) async {
    if (soundId == 'none') return;
    final option = QuickButtonSoundOption.findById(soundId);
    if (option == null || option.assetPath == null) return;
    await _play(option.assetPath!);
  }

  Future<void> previewSound(String soundId) async {
    if (soundId == 'none') return;
    final option = QuickButtonSoundOption.findById(soundId);
    if (option == null || option.assetPath == null) return;
    await _play(option.assetPath!);
  }

  Future<void> stop() async {
    await _player?.stop();
    await _player?.dispose();
    _player = null;
  }

  Future<void> _play(String assetPath) async {
    try {
      await _player?.stop();
      await _player?.dispose();
      _player = AudioPlayer();
      await _player?.play(AssetSource(assetPath));
    } catch (_) {
    }
  }

  void dispose() {
    _player?.stop();
    _player?.dispose();
    _player = null;
  }
}
