
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/core/constants/faculty_constants.dart';

class FacultyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final List<Widget>? actions;

  const FacultyAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: facultyHeadlineLarge),
          Text(subtitle, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
        ],
      ),
      actions: actions,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40); // Increased height for subtitle
}
