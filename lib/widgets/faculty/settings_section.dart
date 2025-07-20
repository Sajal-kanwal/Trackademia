
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/common/setting_item.dart';

class SettingsSection extends StatelessWidget {
  final List<SettingItem> settings;

  const SettingsSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...settings,
        ],
      ),
    );
  }
}
