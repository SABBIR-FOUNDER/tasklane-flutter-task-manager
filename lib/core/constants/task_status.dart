class TaskStatus {
  TaskStatus._();

  static const String newTask = 'New';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';

  static const List<String> values = [
    newTask,
    inProgress,
    completed,
    cancelled,
  ];
}
