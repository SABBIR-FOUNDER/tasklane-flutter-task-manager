class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime? createdDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.createdDate,
  });

  factory TaskModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TaskModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdDate: json['createdDate'] != null
          ? DateTime.parse(
        json['createdDate'],
      )
          : null,
    );
  }
}