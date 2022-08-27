import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../../constants/index.dart';
import 'info_row.dart';

class ProfileSettings extends StatelessWidget {
  ProfileSettings({
    Key? key,
  }) : super(key: key);

  List<String> settings = [
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
      height: 600,
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.only(),
              ),
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Post an Item You are Looking For',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Register as Producer',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Recently Viewed',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Chat with Moderator',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Give Us Feedback',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'File a Complaint',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Documentation',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              // leading: Icon(Icons.wb_sunny),
              title: Text(
                'Delete my Account permanently',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
