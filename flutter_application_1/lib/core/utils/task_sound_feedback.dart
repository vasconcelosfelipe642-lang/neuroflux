import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Feedback sonoro leve ao concluir tarefa.
/// Descomente o asset em [pubspec.yaml] quando `assets/sounds/complete.mp3` existir.
class TaskSoundFeedback {
  TaskSoundFeedback._();
  static final instance = TaskSoundFeedback._();

  // static const _soundPath = 'sounds/complete.mp3';
  static const _soundEnabled = false;

  AudioPlayer? _player;

  Future<void> playComplete() async {
    if (!_soundEnabled) return;
    try {
      _player ??= AudioPlayer();
      await _player!.play(AssetSource('sounds/complete.mp3'));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('TaskSoundFeedback: som indisponível ($e)');
      }
    }
  }
}
