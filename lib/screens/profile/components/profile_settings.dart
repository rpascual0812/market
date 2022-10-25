// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:market/components/setting_tile.dart';
import 'package:market/screens/post/post_looking_for.dart';
import 'package:market/screens/profile/components/recently_viewed_page.dart';

import '../../approot/app_root.dart';
import '../../chat/moderator.dart';
import '../../producer/my_producer_page/my_producer_page.dart';
import '../../producer/producer_register/producer_register.dart';
import '../../terms/terms_page.dart';
import 'complaint.dart';
import 'faq_page.dart';
import 'give_us_feedback.dart';

class ProfileSettings extends StatelessWidget {
  ProfileSettings({
    Key? key,
  }) : super(key: key);

  final List<String> settings = [
    'Post an Item You are Looking For',
    'Register as Producer',
    'Go to Producer\'s Page',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 600,
            width: MediaQuery.of(context).size.width,
            // height: 580,
            child: Column(
              children: <Widget>[
                SettingTile(
                    name: 'Post an Item You are Looking For',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostLookingFor(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Register as Producer',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProducerRegister(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Go to Producer\'s Page',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyProducerPage(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Recently Viewed',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecentlyViewedPage(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Frequently Asked Questions',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FaqPage(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Chat with Moderator',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Moderator(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Give Us Feedback',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GiveUsFeedback(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'File a Complaint',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Complaint(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Documentation',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsPage(),
                        ),
                      );
                    }),
                SettingTile(
                    name: 'Delete my Account permanently',
                    callback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppRoot(jwt: ''),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
