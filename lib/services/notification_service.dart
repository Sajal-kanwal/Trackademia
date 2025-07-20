
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:notesheet_tracker/models/notification_model.dart';

class NotificationService {
  final sb.SupabaseClient _client = sb.Supabase.instance.client;

  Future<List<AppNotification>> getNotifications(String userId) async {
    try {
      final response = await _client
          .from('notifications')
          .select()
          .eq('student_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((item) => AppNotification.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }
}
