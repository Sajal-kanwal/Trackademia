
import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  final VoidCallback onTap;

  const FilterIcon({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: onTap,
    );
  }
}
