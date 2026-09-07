import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_timer_model.dart';

class TaskTimerService {
  static const String _timerKey =
      'tasklane_active_task_timer';

  Future<TaskTimerModel?> loadTimer() async {
    final prefs =
        await SharedPreferences.getInstance();

    final raw = prefs.getString(
      _timerKey,
    );

    if (raw == null ||
        raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded =
          jsonDecode(raw);

      if (decoded
          is! Map<String, dynamic>) {
        await clearTimer();
        return null;
      }

      return TaskTimerModel.fromJson(
        decoded,
      );
    } catch (_) {
      await clearTimer();
      return null;
    }
  }

  Future<void> saveTimer(
    TaskTimerModel timer,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _timerKey,
      jsonEncode(
        timer.toJson(),
      ),
    );
  }

  Future<void> clearTimer() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _timerKey,
    );
  }
}
