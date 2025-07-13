
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/notification_provider.dart';
import 'package:notesheet_tracker/core/themes/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsyncValue = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor)),
      ),
      body: notificationsAsyncValue.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text('No new notifications.', style: Theme.of(context).textTheme.bodyMedium),
            );
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(notification.title, style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Text(notification.message, style: Theme.of(context).textTheme.bodyMedium),
                  trailing: notification.isRead
                      ? SvgPicture.asset(
                          'assets/icons/check.svg',
                          colorFilter: ColorFilter.mode(AppTheme.statusApproved, BlendMode.srcIn),
                          height: 24,
                        )
                      : SvgPicture.asset(
                          'assets/icons/circle.svg',
                          colorFilter: ColorFilter.mode(AppTheme.statusSubmitted, BlendMode.srcIn),
                          height: 24,
                        ),
                  onTap: () {
                    if (!notification.isRead) {
                      ref.read(notificationNotifierProvider.notifier).markAsRead(notification.id);
                    }
                    // TODO: Navigate to relevant notesheet if notesheetId is present
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}
