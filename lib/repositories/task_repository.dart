import '../models/task_model.dart';
import '../models/task_status_count_model.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService _taskService = TaskService();

  Future<List<TaskModel>> getTasksByStatus(
    String status,
  ) {
    return _taskService.getTasksByStatus(
      status,
    );
  }

  Future<TaskModel> createTask(
    Map<String, dynamic> data,
  ) {
    return _taskService.createTask(
      data,
    );
  }

  Future<TaskStatusCountModel>
      getTaskStatusCount() {
    return _taskService.getTaskStatusCount();
  }

  Future<void> updateTaskStatus(
    String taskId,
    String status,
  ) {
    return _taskService.updateTaskStatus(
      taskId,
      status,
    );
  }

  Future<void> deleteTask(
    String taskId,
  ) {
    return _taskService.deleteTask(
      taskId,
    );
  }
}
