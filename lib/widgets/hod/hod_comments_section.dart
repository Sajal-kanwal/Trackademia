
import 'package:flutter/material.dart';

class HODCommentsSection extends StatefulWidget {
  final String placeholder;
  final Function(String) onSubmit;

  const HODCommentsSection({
    super.key,
    required this.placeholder,
    required this.onSubmit,
  });

  @override
  State<HODCommentsSection> createState() => _HODCommentsSectionState();
}

class _HODCommentsSectionState extends State<HODCommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _commentController,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              widget.onSubmit(_commentController.text);
              _commentController.clear();
            },
          ),
        ),
        onSubmitted: (comment) {
          widget.onSubmit(comment);
          _commentController.clear();
        },
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
