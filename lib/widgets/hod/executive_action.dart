
import 'package:flutter/material.dart';

class ExecutiveAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String description;
  final VoidCallback onTap;

  const ExecutiveAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
