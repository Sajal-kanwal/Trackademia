
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';

class FacultyApprovedList extends StatelessWidget {
  final List<Notesheet> submissions;
  final Widget Function(Notesheet submission, int index) itemBuilder;

  const FacultyApprovedList({
    super.key,
    required this.submissions,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: submissions.length,
      itemBuilder: (context, index) {
        return itemBuilder(submissions[index], index);
      },
    );
  }
}
