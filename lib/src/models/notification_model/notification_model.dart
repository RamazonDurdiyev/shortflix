class NotificationModel {
  final String? id;
  final String? title;
  final String? body;
  final DateTime? createdAt;
  final int? sentCount;
  final int? successCount;
  final int? failureCount;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.createdAt,
    this.sentCount,
    this.successCount,
    this.failureCount,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final created = json['createdAt'] ?? json['sentAt'];
    return NotificationModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      createdAt: created == null ? null : DateTime.tryParse(created.toString()),
      sentCount: (json['sentCount'] as num?)?.toInt(),
      successCount: (json['successCount'] as num?)?.toInt(),
      failureCount: (json['failureCount'] as num?)?.toInt(),
    );
  }
}
