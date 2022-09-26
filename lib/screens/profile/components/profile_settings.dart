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
      height: 680,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 680,
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
                //   child: Container(
                //     margin: const EdgeInsets.only(bottom: 5),
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.all(15.0),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.1),
                //           spreadRadius: 1,
                //           blurRadius: 1,
                //           offset:
                //               const Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: const [
                //         Text(
                //           'Post an Item You are Looking For',
                //           style: TextStyle(fontSize: AppDefaults.fontSize),
                //         ),
                //         Icon(
                //           Icons.keyboard_arrow_right,
                //           color: Colors.grey,
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Post an Item You are Looking For',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const PostLookingFor(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Register as Producer',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const ProducerRegister(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Go to Producer\'s Page',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const MyProducerPage(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Recently Viewed',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const RecentlyViewedPage(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Frequently Asked Questions',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const FaqPage(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Chat with Moderator',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const Moderator(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Give Us Feedback',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       showDialog(
                //           context: context,
                //           builder: (_) => const GiveUsFeedback());
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'File a Complaint',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       showDialog(
                //           context: context, builder: (_) => const Complaint());
                //     },
                //   ),
                // ),
                // Card(
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Documentation',
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const TermsPage(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Card(
                //   color: AppColors.danger,
                //   child: ListTile(
                //     // leading: FlutterLogo(),
                //     title: const Text(
                //       'Delete my Account permanently',
                //       style: TextStyle(fontSize: 12, color: Colors.white),
                //     ),
                //     trailing: const Icon(Icons.keyboard_arrow_right),
                //     onTap: () {
                //       // Navigator.push(
                //       //   context,
                //       //   MaterialPageRoute(
                //       //     builder: (context) => const AppRoot(),
                //       //   ),
                //       // );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
