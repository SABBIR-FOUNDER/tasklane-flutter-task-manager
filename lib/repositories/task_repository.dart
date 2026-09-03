import '../models/task_model.dart';
import '../services/task_service.dart';
import '../models/task_status_count_model.dart';

class TaskRepository {
  final TaskService _taskService =
  TaskService();
  Future<TaskStatusCountModel> getTaskStatusCount() {

    return _taskService.getTaskStatusCount();

  }
  Future<TaskModel> createTask(
      Map<String, dynamic> data,
      ) {

    return _taskService.createTask(
      data,
    );

  }

  Future<void> deleteTask(
      String taskId,
      ) {

    return _taskService.deleteTask(
      taskId,
    );

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

  Future<List<TaskModel>> getTasksByStatus(
      String status,
      ) {
    return _taskService.getTasksByStatus(
      status,
    );
  }
}