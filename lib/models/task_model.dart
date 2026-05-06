class TaskModel {
  final String taskId;
  final String title;
  final String status;
  final String assignedTo;

  TaskModel({
    required this.taskId,
    required this.title,
    required this.status,
    required this.assignedTo,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'],
      title: map['title'],
      status: map['status'],
      assignedTo: map['assignedTo'],
    );
  }
}