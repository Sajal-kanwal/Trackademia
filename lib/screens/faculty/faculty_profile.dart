import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/faculty_provider.dart';
import 'package:notesheet_tracker/providers/auth_provider.dart';
import 'package:notesheet_tracker/widgets/faculty/profile_header_section.dart';
import 'package:notesheet_tracker/widgets/faculty/profile_info_section.dart';
import 'package:notesheet_tracker/widgets/faculty/settings_section.dart';
import 'package:notesheet_tracker/widgets/faculty/logout_button.dart';
import 'package:notesheet_tracker/widgets/common/profile_field.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';
import 'package:notesheet_tracker/widgets/common/setting_item.dart';

class FacultyProfile extends ConsumerWidget {
  const FacultyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(facultyProfileProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    return profile.when(
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeaderSection(
                profileImage: 'assets/icons/user_faculty.svg',
                name: data.fullName,
                department: data.department ?? 'N/A',
                designation: data.designation ?? 'N/A',
                onEditTap: () {},
              ),
              ProfileInfoSection(
                info: [
                  ProfileField(label: 'Email', value: data.email, editable: false),
                  ProfileField(label: 'Faculty ID', value: data.facultyId ?? 'N/A', editable: false),
                  ProfileField(label: 'Department', value: data.department ?? 'N/A', editable: true),
                  ProfileField(label: 'Designation', value: data.designation ?? 'N/A', editable: true),
                  ProfileField(label: 'Phone', value: data.officePhone ?? 'N/A', editable: true),
                ],
              ),
              SettingsSection(
                settings: [
                  SettingItem(title: 'Change Password', icon: Icons.lock, onTap: () {},
                  ),
                  SettingItem(title: 'Notification Preferences', icon: Icons.notifications, onTap: () {},
                  ),
                  SettingItem(title: 'Theme Settings', icon: Icons.palette, onTap: () {},
                  ),
                ],
              ),
              LogoutButton(
                onTap: () async {
                  await authNotifier.signOut();
                },
              ),
            ],
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stackTrace) => ErrorMessage(message: error.toString()),
    );
  }
}