
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/user_model.dart';

class FacultyReviewSummary extends StatelessWidget {
  final User reviewer;
  final String decision;
  final String? comments;
  final DateTime reviewDate;

  const FacultyReviewSummary({
    super.key,
    required this.reviewer,
    required this.decision,
    this.comments,
    required this.reviewDate,
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
            Text('Faculty Reviewer: ${reviewer.fullName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Decision: ${decision.toUpperCase()}'),
            const SizedBox(height: 8),
            if (comments != null) Text('Comments: $comments'),
            const SizedBox(height: 8),
            Text('Review Date: ${reviewDate.toLocal().toString().split(' ')[0]}'),
          ],
        ),
      ),
    );
  }
}
