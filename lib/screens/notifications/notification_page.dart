import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/models/notification.dart';

import 'package:market/screens/notifications/notification_page_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notifications> notifications = [
    Notifications(
      message: 'Babylyn Beanay stated following you',
      read: false,
    ),
    Notifications(
      message: 'Mia Sue stated following you',
      read: false,
    ),
    Notifications(
      message: 'Check Justin Miguel\'s post on Future Crops',
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
                  message: notifications[index].message,
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
