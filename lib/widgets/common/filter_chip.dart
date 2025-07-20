
import 'package:flutter/material.dart';

class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int? count;
  final VoidCallback onTap;

  const FilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (count != null)
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  '($count)',
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
