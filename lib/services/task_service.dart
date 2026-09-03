import '../core/network/api_client.dart';
import '../models/task_model.dart';

import '../models/task_status_count_model.dart';

class TaskService {
  final ApiClient _apiClient = ApiClient();
  Future<TaskStatusCountModel> getTaskStatusCount() async {

    final response =
    await _apiClient.get(
      '/taskStatusCount',
    );


    return TaskStatusCountModel.fromJson(
      response['data'],
    );
  }
  Future<TaskModel> createTask(
      Map<String, dynamic> data,
      ) async {

    final response =
    await _apiClient.post(
      '/createTask',
      data,
    );

    return TaskModel.fromJson(
      response['data'],
    );
  }
  Future<void> updateTaskStatus(
      String taskId,
      String status,
      ) async {

    await _apiClient.get(
      '/updateTaskStatus/$taskId/$status',
    );

  }

  Future<void> deleteTask(
      String taskId,
      ) async {

    await _apiClient.get(
      '/deleteTask/$taskId',
    );

  }
  Future<List<TaskModel>> getTasksByStatus(
      String status,
      ) async {

    final response =
    await _apiClient.get(
      '/listTaskByStatus/$status',
    );

    final List data =
    response['data'];

    return data
        .map(
          (task) => TaskModel.fromJson(task),
    )
        .toList();
  }
}

