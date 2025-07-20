
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/hod/executive_action.dart';

class HODDecisionPanel extends StatelessWidget {
  final List<ExecutiveAction> actions;

  const HODDecisionPanel({super.key, required this.actions});

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
