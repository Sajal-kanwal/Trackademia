
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
