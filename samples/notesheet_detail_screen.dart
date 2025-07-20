import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/notesheet_model.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/screens/upload/upload_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notesheet_tracker/core/themes/app_theme.dart';

class NotesheetDetailScreen extends ConsumerWidget {
  final Notesheet notesheet;

  const NotesheetDetailScreen({super.key, required this.notesheet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notesheet.title, style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document Preview Section
            if (notesheet.fileUrl.isNotEmpty) ...[
              Text('Document Preview', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildDocumentPreview(notesheet.fileUrl, notesheet.fileName, context),
              const SizedBox(height: 20),
            ],

            // Status Timeline
            Text('Submission Status', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildStatusTimeline(notesheet.status, context),
            const SizedBox(height: 20),

            // Details Section
            Text('Title: ${notesheet.title}', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Description: ${notesheet.description ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Category: ${notesheet.category}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Semester: ${notesheet.semester ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Course Code: ${notesheet.courseCode ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('File Name: ${notesheet.fileName}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('File Size: ${notesheet.fileSize != null ? '${(notesheet.fileSize! / 1024).toStringAsFixed(2)} KB' : 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Status: ${notesheet.status}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Submitted On: ${notesheet.createdAt != null ? notesheet.createdAt!.toLocal().toString().split(' ')[0] : 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),

            if (notesheet.status == 'revision_requested')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // For simplicity, navigating to UploadScreen for resubmission
                    // A more robust solution would pre-fill data or use a dedicated resubmit form
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UploadScreen()),
                    );
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Text('Resubmit Notesheet', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentPreview(String fileUrl, String fileName, BuildContext context) {
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return SizedBox(
        height: 300,
        child: PDFView(
          filePath: fileUrl, // Note: PDFView expects a local file path, not a URL directly.
          // For network PDFs, you'd typically download it first or use a different package.
          // This is a placeholder for local file viewing.
        ),
      );
    } else if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg') ||
        fileName.toLowerCase().endsWith('.png')) {
      return CachedNetworkImage(
        imageUrl: fileUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error, color: Theme.of(context).colorScheme.error),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      return Text('No preview available for this file type.', style: Theme.of(context).textTheme.bodyMedium);
    }
  }

  Widget _buildStatusTimeline(String currentStatus, BuildContext context) {
    final statuses = [
      'submitted',
      'under_review',
      'revision_requested',
      'approved',
      'rejected',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statuses.map((status) {
        final isActive = statuses.indexOf(status) <= statuses.indexOf(currentStatus);
        final isCurrent = status == currentStatus;
        Color statusColor = Colors.grey;
        IconData statusIcon = Icons.circle;

        switch (status) {
          case 'submitted':
            statusColor = isActive ? AppTheme.statusSubmitted : Colors.grey;
            statusIcon = Icons.check_circle;
            break;
          case 'under_review':
            statusColor = isActive ? AppTheme.statusPending : Colors.grey;
            statusIcon = Icons.hourglass_empty;
            break;
          case 'revision_requested':
            statusColor = isActive ? AppTheme.statusRejected : Colors.grey; // Using rejected color for revision requested
            statusIcon = Icons.refresh;
            break;
          case 'approved':
            statusColor = isActive ? AppTheme.statusApproved : Colors.grey;
            statusIcon = Icons.check_circle_outline;
            break;
          case 'rejected':
            statusColor = isActive ? AppTheme.statusRejected : Colors.grey;
            statusIcon = Icons.cancel;
            break;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              status == 'submitted' || status == 'approved'
                  ? SvgPicture.asset(
                      'assets/icons/check.svg',
                      colorFilter: ColorFilter.mode(statusColor, BlendMode.srcIn),
                      height: 20,
                      width: 20,
                    )
                  : status == 'rejected'
                      ? SvgPicture.asset(
                          'assets/icons/xmark.svg',
                          colorFilter: ColorFilter.mode(statusColor, BlendMode.srcIn),
                          height: 20,
                          width: 20,
                        )
                      : Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 10),
              Text(
                status.replaceAll('_', ' ').toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: statusColor,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
