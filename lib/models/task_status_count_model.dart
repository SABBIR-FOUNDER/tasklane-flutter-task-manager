import '../core/constants/task_status.dart';

class TaskStatusCountModel {
  final Map<String, int> counts;

  TaskStatusCountModel({
    required Map<String, int> counts,
  }) : counts = Map.unmodifiable(counts);

  int countFor(String status) {
    return counts[status] ?? 0;
  }

  int get newTask => countFor(TaskStatus.newTask);

  int get inProgressTask =>
      countFor(TaskStatus.inProgress);

  int get completedTask =>
      countFor(TaskStatus.completed);

  int get cancelledTask =>
      countFor(TaskStatus.cancelled);

  factory TaskStatusCountModel.fromJson(
    List<dynamic> json,
  ) {
    final counts = <String, int>{};

    for (final item in json) {
      if (item is! Map) {
        continue;
      }

      final status =
          item['_id']?.toString().trim();

      if (status == null || status.isEmpty) {
        continue;
      }

      final rawSum = item['sum'];

      final sum = rawSum is num
          ? rawSum.toInt()
          : int.tryParse(
                rawSum?.toString() ?? '',
              ) ??
              0;

      counts[status] = sum;
    }

    return TaskStatusCountModel(
      counts: counts,
    );
  }
}
