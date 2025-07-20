
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String? profileImage;
  final String name;
  final String department;
  final String designation;
  final VoidCallback onEditTap;

  const ProfileHeaderSection({
    super.key,
    this.profileImage,
    required this.name,
    required this.department,
    required this.designation,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: profileImage != null
                ? SvgPicture.asset(
                    profileImage!,
                    width: 60,
                    height: 60,
                  )
                : const Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(designation, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(department, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onEditTap,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
