import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/models/notification.dart';

import 'package:market/models/order.dart';
import 'package:market/screens/notifications/notification_page_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notifications> notifications = [
    Notifications(
      title: 'Title 1',
      description: 'Test notifications 1',
      read: false,
    ),
    Notifications(
      title: 'Title 2',
      description: 'Test notifications 2',
      read: false,
    ),
    Notifications(
      title: 'Title 3',
      description: 'Test notifications 3',
      read: false,
    ),
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Appbar(),
            ListView.builder(
              itemCount: notifications.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return NotificationPageTile(
                  title: notifications[index].title,
                  description: notifications[index].description,
                  read: notifications[index].read,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
