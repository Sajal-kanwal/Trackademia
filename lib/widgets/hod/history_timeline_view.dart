
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';

class HistoryTimelineView extends StatelessWidget {
  final List<Notesheet> decisions;
  final String groupBy;
  final Widget Function(Notesheet decision, int index) itemBuilder;

  const HistoryTimelineView({
    super.key,
    required this.decisions,
    required this.groupBy,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // For simplicity, not implementing grouping logic here. Just displaying a list.
    return ListView.builder(
      itemCount: decisions.length,
      itemBuilder: (context, index) {
        return itemBuilder(decisions[index], index);
      },
    );
  }
}
