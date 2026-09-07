
import 'package:audioplayers/audioplayers.dart';

class TimerSoundService {
  TimerSoundService._();

  static final TimerSoundService instance =
      TimerSoundService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playTimerComplete() async {
    await _player.stop();

    await _player.play(
      AssetSource(
        'audio/timer_complete.mp3',
      ),
    );
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
