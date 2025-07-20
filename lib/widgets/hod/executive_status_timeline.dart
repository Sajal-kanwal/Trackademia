
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineStage {
  final String title;
  final DateTime date;
  final String status;

  TimelineStage(this.title, this.date, this.status);
}

class ExecutiveStatusTimeline extends StatelessWidget {
  final List<TimelineStage> stages;
  final bool animateOnLoad;

  const ExecutiveStatusTimeline({
    super.key,
    required this.stages,
    this.animateOnLoad = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(stages.length, (index) {
          final stage = stages[index];
          final isLast = index == stages.length - 1;
          return TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: index == 0,
            isLast: isLast,
            beforeLineStyle: const LineStyle(color: Colors.grey),
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: stage.status == 'completed' ? Colors.green : (stage.status == 'current' ? Colors.blue : Colors.grey),
              padding: const EdgeInsets.all(6),
            ),
            endChild: Container(
              constraints: const BoxConstraints(
                minHeight: 80,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stage.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(stage.date.toLocal().toString().split(' ')[0]),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
