
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/shared/comment_thread.dart';

class CommentsSection extends StatelessWidget {
  final List<String> comments;
  final Function(String) onAddComment;
  final Duration expandAnimation;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.onAddComment,
    required this.expandAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CommentThread(comments: comments, onAddComment: onAddComment),
        ],
      ),
    );
  }
}
