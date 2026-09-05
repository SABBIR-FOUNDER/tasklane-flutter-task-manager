import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/app_exception.dart';
import '../models/task_model.dart';
import '../models/task_status_count_model.dart';

class TaskService {
  final ApiClient _apiClient = ApiClient();

  Future<List<TaskModel>> getTasksByStatus(
    String status,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.listTaskByStatus(status),
      requiresAuth: true,
    );

    final data =
        response is Map ? response['data'] : null;

    if (data is! List) {
      throw AppException(
        'Invalid task list response from server',
      );
    }

    return data
        .whereType<Map>()
        .map(
          (item) => TaskModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<TaskModel> createTask(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.createTask,
      data,
      requiresAuth: true,
    );

    final task =
        response is Map ? response['data'] : null;

    if (task is! Map) {
      throw AppException(
        'Invalid create-task response from server',
      );
    }

    return TaskModel.fromJson(
      Map<String, dynamic>.from(task),
    );
  }

  Future<TaskStatusCountModel>
      getTaskStatusCount() async {
    final response = await _apiClient.get(
      ApiConstants.taskStatusCount,
      requiresAuth: true,
    );

    final data =
        response is Map ? response['data'] : null;

    if (data is! List) {
      throw AppException(
        'Invalid task-count response from server',
      );
    }

    return TaskStatusCountModel.fromJson(
      data,
    );
  }

  Future<void> updateTaskStatus(
    String taskId,
    String status,
  ) async {
    await _apiClient.get(
      ApiConstants.updateTaskStatus(
        taskId,
        status,
      ),
      requiresAuth: true,
    );
  }

  Future<void> deleteTask(
    String taskId,
  ) async {
    await _apiClient.get(
      ApiConstants.deleteTask(taskId),
      requiresAuth: true,
    );
  }
}
