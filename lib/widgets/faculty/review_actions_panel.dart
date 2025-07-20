
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/faculty/review_action.dart';

class ReviewActionsPanel extends StatelessWidget {
  final List<ReviewAction> actions;

  const ReviewActionsPanel({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions,
      ),
    );
  }
}
