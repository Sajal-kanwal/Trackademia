
import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(value),
              if (editable) const Icon(Icons.edit, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
