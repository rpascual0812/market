import 'dart:async';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/approot/app_root.dart';
import 'package:market/screens/profile/components/profile_settings.dart';

import 'components/profile_picture_section.dart';
import 'components/statuses_row.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            Appbar(),

            /// Profile Picture
            ProfilePictureSection(
              size: size,
              self: true,
            ),

            // Text(
            //   'Raffier Lee',
            //   style: Theme.of(context)
            //       .textTheme
            //       .headline5
            //       ?.copyWith(fontWeight: FontWeight.bold),
            // ),
            // const Text('raffier.lee@gmail.com'),
            // const SizedBox(height: 10),

            /// Statuses
            const StatusesRow(),
            const SizedBox(height: 10),

            /// Personal Information
            ProfileSettings(),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  AppDefaults.toastSuccess(
                      context, AppMessage.getSuccess('LOGOUT_SUCCESS'));

                  Timer(
                    const Duration(seconds: 1),
                    () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppRoot(jwt: ''),
                        ),
                      )
                    },
                  );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const AppRoot(jwt: ''),
                  //   ),
                  // );
                },
                child: const Text('Log Out'),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
