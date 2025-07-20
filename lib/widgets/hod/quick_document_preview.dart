
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/shared/document_viewer.dart';

class QuickDocumentPreview extends StatelessWidget {
  final String fileUrl;
  final String fileName;
  final VoidCallback onFullView;

  const QuickDocumentPreview({
    super.key,
    required this.fileUrl,
    required this.fileName,
    required this.onFullView,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Document: $fileName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DocumentViewer(fileUrl: fileUrl),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: onFullView,
              icon: const Icon(Icons.fullscreen),
              label: const Text('View Full Document'),
            ),
          ),
        ],
      ),
    );
  }
}
