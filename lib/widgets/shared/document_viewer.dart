
import 'package:flutter/material.dart';

class DocumentViewer extends StatelessWidget {
  final String fileUrl;

  const DocumentViewer({super.key, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.picture_as_pdf, size: 50),
          const SizedBox(height: 16),
          Text('Document: $fileUrl'),
        ],
      ),
    );
  }
}
