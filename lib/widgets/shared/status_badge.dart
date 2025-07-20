
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/core/constants/app_colors.dart';
import 'package:notesheet_tracker/core/constants/faculty_constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String text = status;

    switch (status) {
      case 'submitted':
      case 'resubmitted':
        backgroundColor = statusPendingReview;
        break;
      case 'faculty_approved':
        backgroundColor = statusFacultyApproved;
        break;
      case 'faculty_rejected':
        backgroundColor = statusRejected;
        break;
      case 'revision_requested':
        backgroundColor = statusRevisionRequested;
        break;
      case 'final_approved':
        backgroundColor = statusHODApproved;
        break;
      case 'final_rejected':
        backgroundColor = statusHODRejected;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text.replaceAll('_', ' ').toUpperCase(),
        style: statusBadgeText.copyWith(color: Colors.white),
      ),
    );
  }
}
