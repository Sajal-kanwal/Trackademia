
import 'package:flutter/material.dart';

class ReviewPanel extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onRequestChanges;

  const ReviewPanel({
    super.key,
    required this.onApprove,
    required this.onReject,
    required this.onRequestChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: onApprove,
            icon: const Icon(Icons.check),
            label: const Text('Approve'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close),
            label: const Text('Reject'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
          ElevatedButton.icon(
            onPressed: onRequestChanges,
            icon: const Icon(Icons.edit),
            label: const Text('Request Changes'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }
}
