
class Notesheet {
  final String? id;
  final String studentId;
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

  Notesheet({
    this.id,
    required this.studentId,
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
  });

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
    };
  }

  factory Notesheet.fromMap(Map<String, dynamic> map) {
    return Notesheet(
      id: map['id'] as String?,
      studentId: map['student_id'] as String,
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
    );
  }
}
