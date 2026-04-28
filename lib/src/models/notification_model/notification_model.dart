class NotificationActor {
  final String? id;
  final String? fullName;
  final String? avatar;

  NotificationActor({this.id, this.fullName, this.avatar});

  factory NotificationActor.fromJson(Map<String, dynamic> json) {
    return NotificationActor(
      id: (json['_id'] ?? json['id'])?.toString(),
      fullName: json['fullName']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }
}

class NotificationModel {
  final String? id;
  final String? type;
  final NotificationActor? actor;
  final String? movieId;
  final String? episodeId;
  final String? commentId;
  final bool isRead;
  final DateTime? createdAt;
  // Legacy / broadcast fields (kept for backwards compatibility).
  final String? title;
  final String? body;
  final int? sentCount;
  final int? successCount;
  final int? failureCount;

  NotificationModel({
    this.id,
    this.type,
    this.actor,
    this.movieId,
    this.episodeId,
    this.commentId,
    this.isRead = true,
    this.createdAt,
    this.title,
    this.body,
    this.sentCount,
    this.successCount,
    this.failureCount,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final actorRaw = json['actor'];
    final created = json['createdAt'] ?? json['sentAt'];
    return NotificationModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      type: json['type']?.toString(),
      actor: actorRaw is Map
          ? NotificationActor.fromJson(Map<String, dynamic>.from(actorRaw))
          : null,
      movieId: json['movieId']?.toString(),
      episodeId: json['episodeId']?.toString(),
      commentId: json['commentId']?.toString(),
      isRead: json['isRead'] == true,
      createdAt: created == null ? null : DateTime.tryParse(created.toString()),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      sentCount: (json['sentCount'] as num?)?.toInt(),
      successCount: (json['successCount'] as num?)?.toInt(),
      failureCount: (json['failureCount'] as num?)?.toInt(),
    );
  }
}
