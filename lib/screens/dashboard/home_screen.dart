
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notesheet_tracker/providers/notification_provider.dart';
import 'package:notesheet_tracker/providers/profile_provider.dart';
import 'package:notesheet_tracker/providers/notesheet_provider.dart';
import 'package:notesheet_tracker/widgets/common/shimmer_loading.dart';
import 'package:notesheet_tracker/widgets/common/animated_button.dart';
import 'package:notesheet_tracker/core/themes/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:notesheet_tracker/screens/upload/upload_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(userProfileProvider);
    final notificationsAsyncValue = ref.watch(notificationsProvider);
    final notesheetCountsAsyncValue = ref.watch(notesheetCountsProvider);
    final notesheetsAsyncValue = ref.watch(notesheetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            userProfileAsyncValue.when(
              data: (userProfile) => Text(
                'Welcome, ${userProfile?.fullName.split(' ').first ?? 'Student'}!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              loading: () => ShimmerLoading(
                isLoading: true,
                child: Container(
                  height: 30,
                  width: 150,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              error: (error, stack) => Text('Error: ${error.toString()}'),
            ),
            const SizedBox(height: 24),

            // Notification Preview
            notificationsAsyncValue.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return const SizedBox.shrink();
                }
                final latestNotification = notifications.first;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.secondary),
                    title: Text(latestNotification.title, style: Theme.of(context).textTheme.bodyLarge),
                    subtitle: Text(latestNotification.message, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurface),
                    onTap: () {
                      // Navigate to NotificationsScreen
                      context.go('/notifications'); // Assuming /notifications is the route for NotificationsScreen
                    },
                  ),
                );
              },
              loading: () => ShimmerLoading(
                isLoading: true,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurface),
                    title: Container(height: 10, width: 100, color: Theme.of(context).colorScheme.surface),
                    subtitle: Container(height: 10, width: 150, color: Theme.of(context).colorScheme.surface),
                  ),
                ),
              ),
              error: (error, stack) => Text('Error: ${error.toString()}'),
            ),

            // Stats Cards (2x2 Grid)
            notesheetCountsAsyncValue.when(
              data: (counts) => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    context,
                    'Total Submissions',
                    (counts['submitted'] ?? 0) +
                        (counts['under_review'] ?? 0) +
                        (counts['approved'] ?? 0) +
                        (counts['rejected'] ?? 0) +
                        (counts['revision_requested'] ?? 0),
                    const Icon(Icons.description),
                    AppTheme.statusSubmitted,
                  ),
                  _buildStatCard(
                    context,
                    'Pending Reviews',
                    (counts['under_review'] ?? 0) + (counts['revision_requested'] ?? 0),
                    const Icon(Icons.pending_actions),
                    AppTheme.statusPending,
                  ),
                  _buildStatCard(
                    context,
                    'Approved',
                    counts['approved'] ?? 0,
                    const Icon(Icons.check_circle),
                    AppTheme.statusApproved,
                  ),
                  _buildStatCard(
                    context,
                    'Rejected',
                    counts['rejected'] ?? 0,
                    const Icon(Icons.cancel),
                    AppTheme.statusRejected,
                  ),
                ],
              ),
              loading: () => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(4, (index) => ShimmerLoading(
                  isLoading: true,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 32, width: 32, color: Theme.of(context).colorScheme.surface),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 24, width: 50, color: Theme.of(context).colorScheme.surface),
                              const SizedBox(height: 4),
                              Container(height: 12, width: 80, color: Theme.of(context).colorScheme.surface),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
              error: (error, stack) => Text('Error loading stats: ${error.toString()}'),
            ),
            const SizedBox(height: 24),

            // Recent Activity Section
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            notesheetsAsyncValue.when(
              data: (notesheets) {
                if (notesheets.isEmpty) {
                  return Center(child: Text('No recent activity.', style: Theme.of(context).textTheme.bodyMedium));
                }
                return AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notesheets.length > 3 ? 3 : notesheets.length, // Show top 3 recent
                    itemBuilder: (context, index) {
                      final notesheet = notesheets[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(notesheet.title, style: Theme.of(context).textTheme.bodyLarge),
                                subtitle: Text('Status: ${notesheet.status}', style: Theme.of(context).textTheme.bodyMedium),
                                trailing: Text(notesheet.createdAt != null ? notesheet.createdAt!.toLocal().toString().split(' ')[0] : '', style: Theme.of(context).textTheme.bodySmall),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => AnimationLimiter(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: ShimmerLoading(
                          isLoading: true,
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Container(height: 10, width: 100, color: Theme.of(context).colorScheme.surface),
                              subtitle: Container(height: 10, width: 150, color: Theme.of(context).colorScheme.surface),
                              trailing: Container(height: 10, width: 50, color: Theme.of(context).colorScheme.surface),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              error: (error, stack) => Text('Error loading recent activity: ${error.toString()}'),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: AnimatedButton(
                    onPressed: () {
                      // Navigate to Upload Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UploadScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/cloud-upload.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondary, BlendMode.srcIn),
                          height: 24,
                        ),
                        const SizedBox(height: 8),
                        Text('Upload Document', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnimatedButton(
                    onPressed: () {
                      // Navigate to Profile Screen
                      // Assuming profile screen is at index 2 in DashboardScreen's PageView
                      // This is a temporary navigation, will be replaced by go_router later
                      // For now, we'll just go to the profile screen directly
                      context.go('/profile'); // Assuming /profile is the route for ProfileScreen
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/user.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                          height: 24,
                        ),
                        const SizedBox(height: 8),
                        Text('View Profile', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int count, Widget iconWidget, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconWidget,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

