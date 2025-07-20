
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/user_model.dart';

class StudentInfoCard extends StatelessWidget {
  final User student;
  final DateTime submissionDate;
  final String category;

  const StudentInfoCard({
    super.key,
    required this.student,
    required this.submissionDate,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student: ${student.fullName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Submission Date: ${submissionDate.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Category: $category'),
          ],
        ),
      ),
    );
  }
}
