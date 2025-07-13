
class AppNotification {
  final String id;
  final String studentId;
  final String title;
  final String message;
  final String type;
  final String? notesheetId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.studentId,
    required this.title,
    required this.message,
    required this.type,
    this.notesheetId,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      studentId: map['student_id'],
      title: map['title'],
      message: map['message'],
      type: map['type'],
      notesheetId: map['notesheet_id'],
      isRead: map['is_read'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'title': title,
      'message': message,
      'type': type,
      'notesheet_id': notesheetId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? id,
    String? studentId,
    String? title,
    String? message,
    String? type,
    String? notesheetId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      notesheetId: notesheetId ?? this.notesheetId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
