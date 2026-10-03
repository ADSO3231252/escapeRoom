import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager._();

  static final AudioManager instance = AudioManager._();

  final AudioPlayer _player = AudioPlayer();

  bool _initialized = false;
  double _volume = 0.70;

  Future<void> initialize() async {
    if (_initialized) return;

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(_volume);

    _initialized = true;
  }

  Future<void> playBackgroundMusic() async {
    try {
      await initialize();

      if (_player.state == PlayerState.playing) {
        return;
      }

      await _player.play(
        AssetSource('audio/background_music.mp3'),
      );
    } catch (e) {
      // El juego debe continuar aunque el audio falle.
      print('No se pudo reproducir la música: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error al detener la música: $e');
    }
  }

  Future<void> pauseMusic() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Error al pausar la música: $e');
    }
  }

  Future<void> resumeMusic() async {
    try {
      await _player.resume();
    } catch (e) {
      print('Error al reanudar la música: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _player.setVolume(_volume);
    } catch (e) {
      print('Error al cambiar volumen: $e');
    }
  }

  bool get isPlaying => _player.state == PlayerState.playing;

  double get volume => _volume;
}