import 'package:flutter/foundation.dart';

import '../core/constants/task_status.dart';
import '../models/task_model.dart';
import '../models/task_status_count_model.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository =
      TaskRepository();

  final Map<String, List<TaskModel>>
      _tasksByStatus = {};

  final Set<String> _loadingStatuses = {};

  final Map<String, String?>
      _errorsByStatus = {};

  TaskStatusCountModel? _count;

  bool _isCountLoading = false;

  String? _error;

  TaskStatusCountModel? get count => _count;

  bool get isCountLoading => _isCountLoading;

  bool get isLoading =>
      _loadingStatuses.isNotEmpty;

  String? get error => _error;

  List<TaskModel> get tasks =>
      tasksFor(TaskStatus.newTask);

  List<TaskModel> tasksFor(
    String status,
  ) {
    return List.unmodifiable(
      _tasksByStatus[status] ??
          const <TaskModel>[],
    );
  }

  bool isLoadingStatus(
    String status,
  ) {
    return _loadingStatuses.contains(
      status,
    );
  }

  String? errorFor(
    String status,
  ) {
    return _errorsByStatus[status];
  }

  Future<bool> loadTasks(
    String status,
  ) async {
    _loadingStatuses.add(status);
    _errorsByStatus[status] = null;

    notifyListeners();

    try {
      _tasksByStatus[status] =
          await _repository
              .getTasksByStatus(status);

      _error = null;

      return true;
    } catch (e) {
      final message = e.toString();

      _errorsByStatus[status] = message;
      _error = message;

      debugPrint(
        'LOAD TASKS [$status] ERROR: $message',
      );

      return false;
    } finally {
      _loadingStatuses.remove(status);

      notifyListeners();
    }
  }

  Future<void> loadAllTaskLists() async {
    await Future.wait(
      TaskStatus.values.map(loadTasks),
    );
  }

  Future<bool> loadTaskCount() async {
    _isCountLoading = true;

    notifyListeners();

    try {
      _count =
          await _repository
              .getTaskStatusCount();

      _error = null;

      return true;
    } catch (e) {
      _error = e.toString();

      debugPrint(
        'TASK COUNT ERROR: $_error',
      );

      return false;
    } finally {
      _isCountLoading = false;

      notifyListeners();
    }
  }

  Future<bool> createTask(
    Map<String, dynamic> data,
  ) async {
    _error = null;

    try {
      final requestedStatus =
          data['status']
              ?.toString()
              .trim();

      final desiredStatus =
          TaskStatus.values
                  .contains(requestedStatus)
              ? requestedStatus!
              : TaskStatus.newTask;

      final createdTask =
          await _repository.createTask({
        'title':
            data['title']
                    ?.toString()
                    .trim() ??
                '',
        'description':
            data['description']
                    ?.toString()
                    .trim() ??
                '',
        'status': TaskStatus.newTask,
      });

      if (desiredStatus !=
          TaskStatus.newTask) {
        await _repository.updateTaskStatus(
          createdTask.id,
          desiredStatus,
        );
      }

      await _refreshStatuses({
        TaskStatus.newTask,
        desiredStatus,
      });

      await loadTaskCount();

      return true;
    } catch (e) {
      _error = e.toString();

      debugPrint(
        'CREATE TASK ERROR: $_error',
      );

      notifyListeners();

      return false;
    }
  }

  Future<bool> updateTaskStatus(
    String taskId,
    String status, {
    required String fromStatus,
  }) async {
    if (!TaskStatus.values.contains(status)) {
      _error = 'Unsupported task status: $status';

      notifyListeners();

      return false;
    }

    if (status == fromStatus) {
      return true;
    }

    _error = null;

    try {
      await _repository.updateTaskStatus(
        taskId,
        status,
      );

      await _refreshStatuses({
        fromStatus,
        status,
      });

      await loadTaskCount();

      return true;
    } catch (e) {
      _error = e.toString();

      debugPrint(
        'UPDATE TASK STATUS ERROR: $_error',
      );

      notifyListeners();

      return false;
    }
  }

  Future<bool> deleteTask(
    String taskId, {
    required String status,
  }) async {
    _error = null;

    try {
      await _repository.deleteTask(
        taskId,
      );

      await loadTasks(status);
      await loadTaskCount();

      return true;
    } catch (e) {
      _error = e.toString();

      debugPrint(
        'DELETE TASK ERROR: $_error',
      );

      notifyListeners();

      return false;
    }
  }

  Future<void> _refreshStatuses(
    Set<String> statuses,
  ) async {
    await Future.wait(
      statuses.map(loadTasks),
    );
  }
}
