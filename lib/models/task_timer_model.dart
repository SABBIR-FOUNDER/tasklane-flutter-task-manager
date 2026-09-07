class TaskTimerModel {
  final String taskId;
  final String taskTitle;
  final int durationSeconds;
  final int remainingSeconds;
  final DateTime? endsAt;
  final bool isRunning;

  const TaskTimerModel({
    required this.taskId,
    required this.taskTitle,
    required this.durationSeconds,
    required this.remainingSeconds,
    required this.endsAt,
    required this.isRunning,
  });

  bool get isFinished =>
      !isRunning && remainingSeconds <= 0;

  TaskTimerModel copyWith({
    String? taskId,
    String? taskTitle,
    int? durationSeconds,
    int? remainingSeconds,
    DateTime? endsAt,
    bool clearEndsAt = false,
    bool? isRunning,
  }) {
    return TaskTimerModel(
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      durationSeconds:
          durationSeconds ?? this.durationSeconds,
      remainingSeconds:
          remainingSeconds ?? this.remainingSeconds,
      endsAt:
          clearEndsAt ? null : endsAt ?? this.endsAt,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskTitle': taskTitle,
      'durationSeconds': durationSeconds,
      'remainingSeconds': remainingSeconds,
      'endsAt': endsAt?.toIso8601String(),
      'isRunning': isRunning,
    };
  }

  factory TaskTimerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TaskTimerModel(
      taskId:
          json['taskId']?.toString() ?? '',
      taskTitle:
          json['taskTitle']?.toString() ?? '',
      durationSeconds:
          json['durationSeconds'] is int
              ? json['durationSeconds'] as int
              : int.tryParse(
                    json['durationSeconds']
                            ?.toString() ??
                        '',
                  ) ??
                  0,
      remainingSeconds:
          json['remainingSeconds'] is int
              ? json['remainingSeconds'] as int
              : int.tryParse(
                    json['remainingSeconds']
                            ?.toString() ??
                        '',
                  ) ??
                  0,
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.tryParse(
              json['endsAt'].toString(),
            ),
      isRunning:
          json['isRunning'] == true,
    );
  }
}
