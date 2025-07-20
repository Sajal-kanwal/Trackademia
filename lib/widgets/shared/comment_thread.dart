
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class CommentThread extends StatelessWidget {
  final List<String> comments;
  final Function(String) onAddComment;

  const CommentThread({super.key, required this.comments, required this.onAddComment});

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      collapsed: const SizedBox.shrink(),
      expanded: Column(
        children: [
          ...comments.map((comment) => ListTile(title: Text(comment))),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Add a comment...',
            ),
            onSubmitted: onAddComment,
          ),
        ],
      ),
    );
  }
}
