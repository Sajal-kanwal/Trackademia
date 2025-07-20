
class Notesheet {
  final String? id;
  final String studentId;
  final String? studentName; // Added for UI display
  final String title;
  final String? description;
  final String category;
  final String? semester;
  final String? courseCode;
  final String fileUrl;
  final String fileName;
  final int? fileSize;
  final String status;
  final int submissionCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? facultyReviewerId; // Added for tracking
  final String? facultyReviewerName; // Added for UI display
  final DateTime? facultyReviewedAt; // Added for tracking
  final String? hodReviewerId; // Added for tracking
  final DateTime? hodReviewedAt; // Added for tracking
  final String? priorityLevel; // Added for tracking

  Notesheet({
    this.id,
    required this.studentId,
    this.studentName,
    required this.title,
    this.description,
    required this.category,
    this.semester,
    this.courseCode,
    required this.fileUrl,
    required this.fileName,
    this.fileSize,
    this.status = 'submitted',
    this.submissionCount = 1,
    this.createdAt,
    this.updatedAt,
    this.facultyReviewerId,
    this.facultyReviewerName,
    this.facultyReviewedAt,
    this.hodReviewerId,
    this.hodReviewedAt,
    this.priorityLevel,
  });

  Notesheet copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? title,
    String? description,
    String? category,
    String? semester,
    String? courseCode,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? status,
    int? submissionCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? facultyReviewerId,
    String? facultyReviewerName,
    DateTime? facultyReviewedAt,
    String? hodReviewerId,
    DateTime? hodReviewedAt,
    String? priorityLevel,
  }) {
    return Notesheet(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      semester: semester ?? this.semester,
      courseCode: courseCode ?? this.courseCode,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      status: status ?? this.status,
      submissionCount: submissionCount ?? this.submissionCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      facultyReviewerId: facultyReviewerId ?? this.facultyReviewerId,
      facultyReviewerName: facultyReviewerName ?? this.facultyReviewerName,
      facultyReviewedAt: facultyReviewedAt ?? this.facultyReviewedAt,
      hodReviewerId: hodReviewerId ?? this.hodReviewerId,
      hodReviewedAt: hodReviewedAt ?? this.hodReviewedAt,
      priorityLevel: priorityLevel ?? this.priorityLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'title': title,
      'description': description,
      'category': category,
      'semester': semester,
      'course_code': courseCode,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'status': status,
      'submission_count': submissionCount,
      'faculty_reviewer_id': facultyReviewerId,
      'faculty_reviewed_at': facultyReviewedAt?.toIso8601String(),
      'hod_reviewer_id': hodReviewerId,
      'hod_reviewed_at': hodReviewedAt?.toIso8601String(),
      'priority_level': priorityLevel,
    };
  }

  factory Notesheet.fromMap(Map<String, dynamic> map) {
    return Notesheet(
      id: map['id'] as String?,
      studentId: map['student_id'] as String,
      studentName: map['student_name'] as String?, // Assuming this comes from a join
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      semester: map['semester'] as String?,
      courseCode: map['course_code'] as String?,
      fileUrl: map['file_url'] as String,
      fileName: map['file_name'] as String,
      fileSize: map['file_size'] as int?,
      status: map['status'] as String,
      submissionCount: map['submission_count'] as int,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      facultyReviewerId: map['faculty_reviewer_id'] as String?,
      facultyReviewerName: map['faculty_reviewer_name'] as String?, // Assuming this comes from a join
      facultyReviewedAt: map['faculty_reviewed_at'] != null ? DateTime.parse(map['faculty_reviewed_at']) : null,
      hodReviewerId: map['hod_reviewer_id'] as String?,
      hodReviewedAt: map['hod_reviewed_at'] != null ? DateTime.parse(map['hod_reviewed_at']) : null,
      priorityLevel: map['priority_level'] as String?,
    );
  }
}
