
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesheet_tracker/models/notification_model.dart';
import 'package:notesheet_tracker/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider for the NotificationService instance
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

// FutureProvider to get the list of notifications for the current user
final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];
  final notificationService = ref.watch(notificationServiceProvider);
  return await notificationService.getNotifications(userId);
});

// StateNotifierProvider to handle notification actions like marking as read
final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier(ref.read(notificationServiceProvider));
});

class NotificationNotifier extends StateNotifier<bool> {
  final NotificationService _notificationService;

  NotificationNotifier(this._notificationService) : super(false);

  Future<void> markAsRead(String notificationId) async {
    state = true;
    try {
      await _notificationService.markNotificationAsRead(notificationId);
      // Optionally, re-fetch notifications to update UI
      // ref.refresh(notificationsProvider);
    } finally {
      state = false;
    }
  }
}
