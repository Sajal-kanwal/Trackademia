
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/user_model.dart';

class ExecutiveSummaryCard extends StatelessWidget {
  final User student;
  final User faculty;
  final String facultyDecision;
  final DateTime facultyDate;

  const ExecutiveSummaryCard({
    super.key,
    required this.student,
    required this.faculty,
    required this.facultyDecision,
    required this.facultyDate,
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
            Text('Faculty: ${faculty.fullName}'),
            const SizedBox(height: 8),
            Text('Faculty Decision: ${facultyDecision.toUpperCase()}'),
            const SizedBox(height: 8),
            Text('Faculty Review Date: ${facultyDate.toLocal().toString().split(' ')[0]}'),
          ],
        ),
      ),
    );
  }
}
