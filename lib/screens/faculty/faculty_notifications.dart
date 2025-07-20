import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/notification_provider.dart';
import 'package:notesheet_tracker/widgets/common/animated_slide_in.dart';
import 'package:notesheet_tracker/widgets/faculty/notification_tile.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';
import 'package:go_router/go_router.dart';
import 'package:notesheet_tracker/providers/notesheet_provider.dart';

class FacultyNotifications extends ConsumerWidget {
  const FacultyNotifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsyncValue = ref.watch(notificationsProvider);
    final notificationService = ref.watch(notificationServiceProvider);
    final notesheetService = ref.watch(notesheetServiceProvider);

    return notificationsAsyncValue.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text('No notifications'));
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final notification = data[index];
            return AnimatedSlideIn(
              delay: Duration(milliseconds: index * 50),
              child: NotificationTile(
                notification: notification,
                onTap: () async {
                  if (notification.notesheetId != null) {
                    final notesheet = await notesheetService.getNotesheetById(notification.notesheetId!);
                    if (notesheet != null) {
                      context.go('/faculty/submission/${notesheet.id}', extra: notesheet);
                    }
                  }
                  await notificationService.markNotificationAsRead(notification.id);
                  ref.invalidate(notificationsProvider);
                },
                onDismiss: () async {
                  await notificationService.markNotificationAsRead(notification.id);
                  ref.invalidate(notificationsProvider);
                },
              ),
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stackTrace) => ErrorMessage(message: error.toString()),
    );
  }
}