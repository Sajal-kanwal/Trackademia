
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/shared/document_viewer.dart';

class DocumentPreviewSection extends StatelessWidget {
  final String fileUrl;
  final String fileName;
  final String fileSize;
  final VoidCallback onDownload;
  final VoidCallback onFullscreen;

  const DocumentPreviewSection({
    super.key,
    required this.fileUrl,
    required this.fileName,
    required this.fileSize,
    required this.onDownload,
    required this.onFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Document: $fileName ($fileSize)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DocumentViewer(fileUrl: fileUrl),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download),
                label: const Text('Download'),
              ),
              ElevatedButton.icon(
                onPressed: onFullscreen,
                icon: const Icon(Icons.fullscreen),
                label: const Text('Fullscreen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
