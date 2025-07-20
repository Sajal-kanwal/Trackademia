
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/widgets/common/profile_field.dart';

class ProfileInfoSection extends StatelessWidget {
  final List<ProfileField> info;

  const ProfileInfoSection({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: info,
      ),
    );
  }
}
