
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/task_timer_model.dart';
import '../services/task_timer_service.dart';
import '../services/timer_sound_service.dart';

class TaskTimerProvider extends ChangeNotifier {
  final TaskTimerService _service =
      TaskTimerService();

  final TimerSoundService _soundService =
      TimerSoundService.instance;

  TaskTimerModel? _timer;
  Timer? _ticker;
  bool _initialized = false;

  TaskTimerModel? get timer => _timer;

  bool get isInitialized => _initialized;

  bool get hasTimer => _timer != null;

  bool get isRunning =>
      _timer?.isRunning ?? false;

  bool get isFinished =>
      _timer?.isFinished ?? false;

  Future<void> initialize() async {
    if (_initialized) return;

    _timer = await _service.loadTimer();

    if (_timer != null && _timer!.isRunning) {
      final remaining =
          _calculateRunningRemaining(_timer!);

      if (remaining <= 0) {
        _timer = _timer!.copyWith(
          remainingSeconds: 0,
          isRunning: false,
          clearEndsAt: true,
        );

        await _service.saveTimer(_timer!);
      } else {
        _timer = _timer!.copyWith(
          remainingSeconds: remaining,
        );

        _startTicker();
      }
    }

    _initialized = true;
    notifyListeners();
  }

  bool isTimerForTask(String taskId) {
    return _timer?.taskId == taskId;
  }

  int remainingForTask(String taskId) {
    if (!isTimerForTask(taskId)) return 0;

    final current = _timer;

    if (current == null) return 0;

    if (current.isRunning) {
      return _calculateRunningRemaining(current);
    }

    return current.remainingSeconds;
  }

  String displayForTask(String taskId) {
    if (!isTimerForTask(taskId)) return '';

    final current = _timer;

    if (current == null) return '';

    if (current.isFinished) {
      return "Time's up";
    }

    return _formatDuration(
      remainingForTask(taskId),
    );
  }

  Future<void> startTimer({
    required String taskId,
    required String taskTitle,
    required int durationSeconds,
  }) async {
    if (durationSeconds <= 0) return;

    _ticker?.cancel();

    final now = DateTime.now();

    _timer = TaskTimerModel(
      taskId: taskId,
      taskTitle: taskTitle,
      durationSeconds: durationSeconds,
      remainingSeconds: durationSeconds,
      endsAt: now.add(
        Duration(seconds: durationSeconds),
      ),
      isRunning: true,
    );

    await _service.saveTimer(_timer!);

    _startTicker();
    notifyListeners();
  }

  Future<void> pauseTimer() async {
    final current = _timer;

    if (current == null || !current.isRunning) {
      return;
    }

    final remaining =
        _calculateRunningRemaining(current);

    _ticker?.cancel();

    _timer = current.copyWith(
      remainingSeconds:
          remaining < 0 ? 0 : remaining,
      isRunning: false,
      clearEndsAt: true,
    );

    await _service.saveTimer(_timer!);

    notifyListeners();
  }

  Future<void> resumeTimer() async {
    final current = _timer;

    if (current == null ||
        current.isRunning ||
        current.remainingSeconds <= 0) {
      return;
    }

    _timer = current.copyWith(
      endsAt: DateTime.now().add(
        Duration(
          seconds: current.remainingSeconds,
        ),
      ),
      isRunning: true,
    );

    await _service.saveTimer(_timer!);

    _startTicker();
    notifyListeners();
  }

  Future<void> stopTimer() async {
    _ticker?.cancel();
    _ticker = null;
    _timer = null;

    await _service.clearTimer();

    notifyListeners();
  }

  Future<void> stopTimerForTask(String taskId) async {
    if (isTimerForTask(taskId)) {
      await stopTimer();
    }
  }

  void _startTicker() {
    _ticker?.cancel();

    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleTick(),
    );
  }

  Future<void> _handleTick() async {
    final current = _timer;

    if (current == null || !current.isRunning) {
      return;
    }

    final remaining =
        _calculateRunningRemaining(current);

    if (remaining <= 0) {
      _ticker?.cancel();
      _ticker = null;

      _timer = current.copyWith(
        remainingSeconds: 0,
        isRunning: false,
        clearEndsAt: true,
      );

      await _soundService.playTimerComplete();

      await _service.saveTimer(_timer!);

      notifyListeners();
      return;
    }

    _timer = current.copyWith(
      remainingSeconds: remaining,
    );

    notifyListeners();
  }

  int _calculateRunningRemaining(
      TaskTimerModel timer) {
    final endsAt = timer.endsAt;

    if (endsAt == null) {
      return timer.remainingSeconds;
    }

    final ms = endsAt
        .difference(DateTime.now())
        .inMilliseconds;

    if (ms <= 0) return 0;

    return (ms + 999) ~/ 1000;
  }

  String _formatDuration(int seconds) {
    final safe = seconds < 0 ? 0 : seconds;

    final hours = safe ~/ 3600;
    final minutes = (safe % 3600) ~/ 60;
    final secs = safe % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2,'0')}:'
          '${minutes.toString().padLeft(2,'0')}:'
          '${secs.toString().padLeft(2,'0')}';
    }

    return '${minutes.toString().padLeft(2,'0')}:'
        '${secs.toString().padLeft(2,'0')}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
