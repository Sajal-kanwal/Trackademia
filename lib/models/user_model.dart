
class User {
  final String id;
  final String email;
  final String fullName;
  final String? studentId;
  final String? department;
  final String? semester;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? role; // Added
  final String? facultyId; // Added
  final String? hodId; // Added
  final String? designation; // Added
  final String? officePhone; // Added
  final String? institution; // Added

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.studentId,
    this.department,
    this.semester,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.role,
    this.facultyId,
    this.hodId,
    this.designation,
    this.officePhone,
    this.institution,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      fullName: map['full_name'],
      studentId: map['student_id'],
      department: map['department'],
      semester: map['semester'],
      profileImageUrl: map['profile_image_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      role: map['role'],
      facultyId: map['faculty_id'],
      hodId: map['hod_id'],
      designation: map['designation'],
      officePhone: map['office_phone'],
      institution: map['institution'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'student_id': studentId,
      'department': department,
      'semester': semester,
      'profile_image_url': profileImageUrl,
      'updated_at': DateTime.now().toIso8601String(),
      'role': role,
      'faculty_id': facultyId,
      'hod_id': hodId,
      'designation': designation,
      'office_phone': officePhone,
      'institution': institution,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? studentId,
    String? department,
    String? semester,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? role,
    String? facultyId,
    String? hodId,
    String? designation,
    String? officePhone,
    String? institution,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
      facultyId: facultyId ?? this.facultyId,
      hodId: hodId ?? this.hodId,
      designation: designation ?? this.designation,
      officePhone: officePhone ?? this.officePhone,
      institution: institution ?? this.institution,
    );
  }
}
