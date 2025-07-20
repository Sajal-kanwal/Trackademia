
import 'package:flutter/material.dart';
import 'package:notesheet_tracker/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      onDismissed: (direction) => onDismiss(),
      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.message),
          trailing: Text(notification.createdAt.toLocal().toString().split(' ')[0]),
          onTap: onTap,
        ),
      ),
    );
  }
}
