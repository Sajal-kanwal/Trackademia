
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HistoryTimeline extends StatelessWidget {
  final List<Map<String, String>> history;

  const HistoryTimeline({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: history.map((item) {
        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: history.first == item,
          isLast: history.last == item,
          beforeLineStyle: const LineStyle(color: Colors.grey),
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: Colors.blue,
            padding: EdgeInsets.all(6),
          ),
          endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['status']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item['date']!),
                  const SizedBox(height: 4),
                  Text(item['changed_by']!),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
