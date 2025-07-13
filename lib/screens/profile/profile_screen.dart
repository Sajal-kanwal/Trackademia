import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/auth_provider.dart';
import 'package:notesheet_tracker/providers/profile_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notesheet_tracker/screens/profile/edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(userProfileProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor)),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/log-out.svg',
              colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.foregroundColor ?? Colors.white, BlendMode.srcIn),
              height: 24,
            ),
            onPressed: () async {
              await authNotifier.signOut();
            },
          ),
        ],
      ),
      body: userProfileAsyncValue.when(
        data: (userProfile) {
          if (userProfile == null) {
            return Center(child: Text('No profile data found.', style: Theme.of(context).textTheme.bodyMedium));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: userProfile.profileImageUrl != null
                        ? NetworkImage(userProfile.profileImageUrl!)
                        : null,
                    child: userProfile.profileImageUrl == null
                        ? SvgPicture.asset(
                            'assets/icons/user.svg',
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                            height: 60,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    userProfile.fullName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Center(
                  child: Text(
                    userProfile.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 24),
                _buildProfileInfoRow('Student ID', userProfile.studentId, context),
                _buildProfileInfoRow('Department', userProfile.department ?? 'N/A', context),
                _buildProfileInfoRow('Semester', userProfile.semester ?? 'N/A', context),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(userProfile: userProfile),
                        ),
                      );
                    },
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}