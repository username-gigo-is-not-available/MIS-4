import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  const NotificationsScreen({Key? key, this.flutterLocalNotificationsPlugin})
      : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: widget.flutterLocalNotificationsPlugin == null
          ? Center(
              child: Text('Notifications not available.'),
            )
          : FutureBuilder<List<PendingNotificationRequest>>(
              future: widget.flutterLocalNotificationsPlugin!
                  .pendingNotificationRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final notifications = snapshot.data!;
                  if (notifications.isEmpty) {
                    return Center(child: Text('No notifications'));
                  }
                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return ListTile(
                        title: Text(notification.title ?? ''),
                        subtitle: Text(notification.body ?? ''),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Failed to load notifications'));
                }
              },
            ),
    );
  }
}
