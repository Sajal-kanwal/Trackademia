
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AnimatedStatusTimeline extends StatelessWidget {
  final List<Map<String, String>> history;
  final String currentStatus;
  final Duration animationDelay;

  const AnimatedStatusTimeline({
    super.key,
    required this.history,
    required this.currentStatus,
    required this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(history.length, (index) {
          final item = history[index];
          final isCurrent = item['status'] == currentStatus;
          return TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: index == 0,
            isLast: index == history.length - 1,
            beforeLineStyle: const LineStyle(color: Colors.grey),
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: isCurrent ? Colors.blue : Colors.grey,
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
                    Text(item['status']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['date']!),
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
