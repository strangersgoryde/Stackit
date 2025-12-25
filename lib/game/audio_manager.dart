import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static bool _initialized = false;
  static bool _audioEnabled = true;
  static AudioPlayer? _bgmPlayer;

  static Future<void> init() async {
    try {
      // IMPORTANT: Set the correct audio assets path (assets/audios/ not assets/audio/)
      FlameAudio.audioCache.prefix = 'assets/audios/';
      
      if (kIsWeb) {
        // On web, don't pre-cache - just mark as initialized
        // We'll play audio directly when needed
        debugPrint('AudioManager: Web platform - audio will play on demand');
        _bgmPlayer = AudioPlayer();
        _initialized = true;
      } else {
        // On native platforms, pre-cache for better performance
        await FlameAudio.audioCache.loadAll([
          'BGM.ogg',
          'Menu.ogg',
          'squish.ogg',
          'thud.ogg',
          'thud2.ogg',
          'pop.ogg',
          'Perfect.ogg',
          'Victory.ogg',
          'fail.ogg',
          'Warning.ogg',
        ]);
        debugPrint('AudioManager: Audio files cached successfully');
        _initialized = true;
      }
    } catch (e) {
      debugPrint('AudioManager: Failed to initialize audio: $e');
      _audioEnabled = false;
    }
  }

  static Future<void> playBgm(String filename) async {
    if (!_audioEnabled || !_initialized) return;
    
    try {
      if (kIsWeb) {
        // On web, use AudioPlayer directly with asset source
        if (_bgmPlayer != null) {
          await _bgmPlayer!.stop();
          await _bgmPlayer!.setReleaseMode(ReleaseMode.loop);
          await _bgmPlayer!.setVolume(0.5);
          await _bgmPlayer!.play(AssetSource('audios/$filename'));
        }
      } else {
        if (!FlameAudio.bgm.isPlaying) {
          FlameAudio.bgm.play(filename, volume: 0.5);
        }
      }
    } catch (e) {
      debugPrint('AudioManager: Failed to play BGM: $e');
      // Disable audio if it fails repeatedly
      _audioEnabled = false;
    }
  }

  static Future<void> stopBgm() async {
    if (!_audioEnabled || !_initialized) return;
    
    try {
      if (kIsWeb) {
        await _bgmPlayer?.stop();
      } else {
        FlameAudio.bgm.stop();
      }
    } catch (e) {
      debugPrint('AudioManager: Failed to stop BGM: $e');
    }
  }

  static Future<void> playSfx(String filename) async {
    if (!_audioEnabled || !_initialized) return;
    
    try {
      if (kIsWeb) {
        // On web, create a new player for each SFX
        final player = AudioPlayer();
        await player.play(AssetSource('audios/$filename'));
        // Release after playing
        player.onPlayerComplete.listen((_) {
          player.dispose();
        });
      } else {
        FlameAudio.play(filename);
      }
    } catch (e) {
      debugPrint('AudioManager: Failed to play SFX: $e');
    }
  }
}

