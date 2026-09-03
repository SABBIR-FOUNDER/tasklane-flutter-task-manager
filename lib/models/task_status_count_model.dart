class TaskStatusCountModel {
  final int newTask;
  final int completedTask;

  TaskStatusCountModel({
    required this.newTask,
    required this.completedTask,
  });

  factory TaskStatusCountModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TaskStatusCountModel(
      newTask: json['New'] ?? 0,
      completedTask: json['Completed'] ?? 0,
    );
  }
}