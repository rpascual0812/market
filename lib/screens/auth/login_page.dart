import 'package:flutter/material.dart';

import '../../constants/app_defaults.dart';
import '../../constants/app_images.dart';
import 'components/login_form.dart';
import 'components/social_icon_button.dart';
import 'sign_up_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              AppImages.logo,
              height: 200,
            ),
            const Spacer(),
            // Header
            const Text(
              "LAMBO",
              style: TextStyle(
                fontFamily: 'RobotoSlabRegular',
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Color(0xff0a5028),
              ),
            ),
            const Text(
              "MAG-UUMA",
              style: TextStyle(
                fontFamily: 'RobotoSlabRegular',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),

            // Login Form
            const LoginForm(),

            const Spacer(),

            /// Or Section
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: const [
            //     HorizontalLine(width: 100),
            //     Text('Or'),
            //     HorizontalLine(width: 100),
            //   ],
            // ),
            // const Spacer(),

            const Spacer(),
            const Spacer(),
            const Spacer(),

            /// Social Login
            // const SocialLogins(),

            // const Spacer(),

            /// Don't have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Text(
                //   'Don\'t have an account?',
                //   style: TextStyle(fontSize: AppDefaults.fontSize),
                // ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Not yet a member?',
                    style: TextStyle(fontSize: AppDefaults.fontSize),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SocialLogins extends StatelessWidget {
  const SocialLogins({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIconButton(
          logoLink: 'https://i.imgur.com/fAYfjAa.png',
          onTap: () {},
        ),
        const SizedBox(width: AppDefaults.margin * 2),
        SocialIconButton(
          logoLink: 'https://i.imgur.com/DzXthZA.png',
          onTap: () {},
        ),
      ],
    );
  }
}
