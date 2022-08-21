import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';

import 'package:market/models/order.dart';
import 'package:market/screens/notifications/notification_page_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<Order> orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshOrders();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();

    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Appbar(),

        /// Use List View Here
        Expanded(
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : !orders.isEmpty
                    ? const Text(
                        'No data found',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      )
                    : buildOrders(),
          ),
        ),
      ],
    );
  }

  Widget buildOrders() => ListView(
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          NotificationPageTile(
            title: 'Title 1',
            description: 'Test notifications 1',
            read: false,
            onTap: () {},
          ),
          NotificationPageTile(
            title: 'Title 2',
            description: 'Test notifications 2',
            read: false,
            onTap: () {},
          ),
          NotificationPageTile(
            title: 'Title 3',
            description: 'Test notifications 3',
            read: false,
            onTap: () {},
          ),
          NotificationPageTile(
            title: 'Title 4',
            description: 'Test notifications 4',
            read: true,
            onTap: () {},
          ),
        ],
      );
}
