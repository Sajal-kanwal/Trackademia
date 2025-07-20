import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/hod_provider.dart';
import 'package:notesheet_tracker/providers/auth_provider.dart';
import 'package:notesheet_tracker/widgets/hod/executive_profile_header.dart';
import 'package:notesheet_tracker/widgets/hod/executive_info_section.dart';
import 'package:notesheet_tracker/widgets/hod/executive_settings_section.dart';
import 'package:notesheet_tracker/widgets/hod/executive_logout_button.dart';
import 'package:notesheet_tracker/widgets/common/profile_field.dart';
import 'package:notesheet_tracker/widgets/common/setting_item.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';

class HODProfile extends ConsumerWidget {
  const HODProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(hodProfileProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    return profile.when(
      data: (data) {
        return Column(
          children: [
            ExecutiveProfileHeader(
              profileImage: 'assets/icons/user-hod.svg',
              name: data.fullName,
              title: 'Head of Department',
              department: data.department ?? 'N/A',
              institution: data.institution ?? 'N/A',
            ),
            ExecutiveInfoSection(
              info: [
                ProfileField(label: 'Email', value: data.email, editable: false),
                ProfileField(label: 'HOD ID', value: data.hodId ?? 'N/A', editable: false),
                ProfileField(label: 'Department', value: data.department ?? 'N/A', editable: false),
                ProfileField(label: 'Institution', value: data.institution ?? 'N/A', editable: true),
                ProfileField(label: 'Office Phone', value: data.officePhone ?? 'N/A', editable: true),
              ],
            ),
            ExecutiveSettingsSection(
              settings: [
                SettingItem(title: 'Change Password', icon: Icons.lock, onTap: () {},
                ),
                SettingItem(title: 'Decision Preferences', icon: Icons.gavel, onTap: () {},
                ),
                SettingItem(title: 'Notification Settings', icon: Icons.notifications, onTap: () {},
                ),
                SettingItem(title: 'Delegation Settings', icon: Icons.supervisor_account, onTap: () {},
                ),
              ],
            ),
            ExecutiveLogoutButton(
              onTap: () async {
                await authNotifier.signOut();
              },
            ),
          ],
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stackTrace) => ErrorMessage(message: error.toString()),
    );
  }
}