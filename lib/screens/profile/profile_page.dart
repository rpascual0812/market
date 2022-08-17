import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/auth/components/login_form.dart';
import 'package:market/screens/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';

import 'components/peronal_informations.dart';
import 'components/profile_picture_section.dart';
import 'components/statuses_row.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            Appbar(),

            /// Profile Picture
            ProfilePictureSection(size: size),

            Text(
              'Alex Nikiforov',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text('alex@msn.com'),
            const SizedBox(height: 10),

            /// Statuses
            const StatusesRow(),
            const SizedBox(height: 10),

            /// Personal Information
            const PeronalInformations(),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OnboardingPage(),
                    ),
                  );
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
