// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:market/screens/approot/app_root.dart';
import 'package:market/screens/post/post_looking_for.dart';
import 'package:market/screens/producer/producer_register/producer_register.dart';
import '../../../constants/index.dart';

class ProfileSettings extends StatelessWidget {
  ProfileSettings({
    Key? key,
  }) : super(key: key);

  final List<String> settings = [
    'Post an Item You are Looking For',
    'Register as Producer',
    'Recently Viewed',
    'Frequently Asked Questions',
    'Chat with Moderator',
    'Give Us Feedback',
    'File a Complaint',
    'Documentation',
    'Delete my Account permanently',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 620,
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: 580,
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Post an Item You are Looking For',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostLookingFor(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Register as Producer',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProducerRegister(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Recently Viewed',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Frequently Asked Questions',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Chat with Moderator',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Give Us Feedback',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'File a Complaint',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Documentation',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: AppColors.danger,
                    child: ListTile(
                      // leading: FlutterLogo(),
                      title: const Text(
                        'Delete my Account permanently',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
