
import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  final String title;
  final String hintText;

  const CommentDialog({super.key, required this.title, required this.hintText});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _commentController,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_commentController.text);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
