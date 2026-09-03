import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import '../models/task_status_count_model.dart';


class TaskProvider extends ChangeNotifier {

  final TaskRepository _repository =
  TaskRepository();
  TaskStatusCountModel? _count;

  TaskStatusCountModel? get count =>
      _count;

  Future<void> deleteTask(
      String taskId,
      ) async {

    try {

      await _repository.deleteTask(
        taskId,
      );


      await loadTasks(
        'New',
      );


      await loadTaskCount();


    } catch(e) {

      debugPrint(
        e.toString(),
      );

    }

  }

  Future<void> updateTaskStatus(
      String taskId,
      String status,
      ) async {

    try {

      await _repository.updateTaskStatus(
        taskId,
        status,
      );


      await loadTasks(
        'New',
      );


      await loadTaskCount();


    } catch(e){

      debugPrint(
        e.toString(),
      );

    }

  }

  Future<void> loadTaskCount() async {

    try {

      _count =
      await _repository.getTaskStatusCount();

      notifyListeners();

    } catch(e){

      debugPrint(
        e.toString(),
      );

    }

  }
  Future<bool> createTask(
      Map<String, dynamic> data,
      ) async {

    try {

      await _repository.createTask(
        data,
      );


      await loadTasks(
        'New',
      );


      return true;


    } catch(e) {

      debugPrint(
        e.toString(),
      );

      return false;

    }
  }
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks =>
      _tasks;


  bool _isLoading = false;

  bool get isLoading =>
      _isLoading;


  Future<void> loadTasks(
      String status,
      ) async {

    _isLoading = true;

    notifyListeners();


    try {

      _tasks =
      await _repository.getTasksByStatus(
        status,
      );


    } catch(e) {

      debugPrint(
        e.toString(),
      );

    }


    _isLoading = false;

    notifyListeners();

  }
}

