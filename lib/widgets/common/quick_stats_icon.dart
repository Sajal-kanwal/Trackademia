
import 'package:flutter/material.dart';

class QuickStatsIcon extends StatelessWidget {
  final int approvalsPending;

  const QuickStatsIcon({super.key, required this.approvalsPending});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () {
            // Handle quick stats icon tap
          },
        ),
        if (approvalsPending > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$approvalsPending',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}
