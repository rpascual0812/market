import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/screens/auth/login_page.dart';
import 'package:market/models/notification.dart';
import 'package:market/screens/notifications/notification_page_tile.dart';

class FollowerList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FollowerListState();
}

class FollowerListState extends State<FollowerList>
    with SingleTickerProviderStateMixin {
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;
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
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
    ),
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
    ),
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
    ),
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
    ),
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
    ),
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
    ),
    Notifications(
      title: 'Title 4',
      description: 'Test notifications 4',
      read: true,
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

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.all(20.0),
          // padding: const EdgeInsets.all(15.0),
          height: 700.0,
          decoration: ShapeDecoration(
            // color: const Color.fromRGBO(41, 167, 77, 10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                width: double.infinity,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    const Text(
                      'Followers',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(close),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        },
                      ),
                    ),
                  ],
                ),
                // child: Row(
                //   children: [
                //     Container(
                //       child: Align(
                //         alignment: Alignment.topRight,
                //         child: Text(
                //           'Following',
                //           style: TextStyle(fontSize: 17, color: Colors.white),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
              ),
              SizedBox(
                height: 615,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
