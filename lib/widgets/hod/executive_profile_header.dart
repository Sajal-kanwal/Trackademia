
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExecutiveProfileHeader extends StatelessWidget {
  final String? profileImage;
  final String name;
  final String title;
  final String department;
  final String institution;

  const ExecutiveProfileHeader({
    super.key,
    this.profileImage,
    required this.name,
    required this.title,
    required this.department,
    required this.institution,
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
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(department, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(institution, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
