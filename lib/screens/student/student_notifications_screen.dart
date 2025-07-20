
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/providers/notification_provider.dart';
import 'package:notesheet_tracker/core/themes/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:notesheet_tracker/widgets/common/loading_indicator.dart';
import 'package:notesheet_tracker/widgets/common/error_message.dart';
import 'package:go_router/go_router.dart';
import 'package:notesheet_tracker/providers/notesheet_provider.dart';

class StudentNotificationsScreen extends ConsumerWidget {
  const StudentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsyncValue = ref.watch(notificationsProvider);
    final notificationService = ref.watch(notificationServiceProvider);
    final notesheetService = ref.watch(notesheetServiceProvider);

    return notificationsAsyncValue.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/empty.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                Text(
                  'No new notifications.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  notification.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: notification.isRead
                    ? SvgPicture.asset(
                        'assets/icons/check.svg',
                        colorFilter: ColorFilter.mode(
                          AppTheme.statusApproved,
                          BlendMode.srcIn,
                        ),
                        height: 24,
                      )
                    : SvgPicture.asset(
                        'assets/icons/circle.svg',
                        colorFilter: ColorFilter.mode(
                          AppTheme.statusSubmitted,
                          BlendMode.srcIn,
                        ),
                        height: 24,
                      ),
                onTap: () async {
                  if (!notification.isRead) {
                    await notificationService.markNotificationAsRead(notification.id);
                    ref.invalidate(notificationsProvider);
                  }
                  if (notification.notesheetId != null) {
                    final notesheet = await notesheetService.getNotesheetById(notification.notesheetId!);
                    if (notesheet != null) {
                      context.go('/notesheet/${notesheet.id}', extra: notesheet);
                    }
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorMessage(message: error.toString()),
    );
  }
}
