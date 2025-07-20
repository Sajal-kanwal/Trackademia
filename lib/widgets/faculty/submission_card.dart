
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:notesheet_tracker/widgets/shared/status_badge.dart';

class SubmissionCard extends StatelessWidget {
  final Notesheet submission;
  final VoidCallback onTap;

  const SubmissionCard({super.key, required this.submission, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(submission.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Submitted by: ${submission.studentName}'),
              const SizedBox(height: 8),
              StatusBadge(status: submission.status),
            ],
          ),
        ),
      ),
    );
  }
}
