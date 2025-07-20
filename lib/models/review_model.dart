class Review {
  final String id;
  final String notesheetId;
  final String reviewerId;
  final String reviewerType;
  final String decision;
  final String? comments;
  final DateTime reviewedAt;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.notesheetId,
    required this.reviewerId,
    required this.reviewerType,
    required this.decision,
    this.comments,
    required this.reviewedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notesheet_id': notesheetId,
      'reviewer_id': reviewerId,
      'reviewer_type': reviewerType,
      'decision': decision,
      'comments': comments,
      'reviewed_at': reviewedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      notesheetId: map['notesheet_id'] as String,
      reviewerId: map['reviewer_id'] as String,
      reviewerType: map['reviewer_type'] as String,
      decision: map['decision'] as String,
      comments: map['comments'] as String?,
      reviewedAt: DateTime.parse(map['reviewed_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}