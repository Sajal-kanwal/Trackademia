
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';

class HistoryDecisionCard extends StatelessWidget {
  final Notesheet decision;
  final VoidCallback onTap;

  const HistoryDecisionCard({super.key, required this.decision, required this.onTap});

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
              Text(decision.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Student: ${decision.studentName}'),
              const SizedBox(height: 8),
              Text('Status: ${decision.status}'),
              const SizedBox(height: 8),
              Text('Decision Date: ${decision.hodReviewedAt?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
            ],
          ),
        ),
      ),
    );
  }
}
