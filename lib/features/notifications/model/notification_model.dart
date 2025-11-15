class NotificationModel {
  final String id;
  final String message;
  final String status;
  final String priority;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.message,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["_id"],
      message: json["message"],
      status: json["status"],
      priority: json["priority"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
