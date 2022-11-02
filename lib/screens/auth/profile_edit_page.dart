import 'package:flutter/material.dart';
import 'package:market/screens/auth/components/profile_edit_form.dart';

import '../../components/horizontal_line.dart';
import '../../constants/index.dart';
import 'login_page.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: const [
                    SizedBox(height: AppDefaults.margin * 1),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "   Registration",
                        style: TextStyle(
                            fontSize: AppDefaults.h7,
                            fontWeight: FontWeight.bold),
                        // style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    SizedBox(height: AppDefaults.margin * 1),
                  ],
                ),
              ),
              ProfileEditForm(user: user),
              Visibility(
                visible: user.isNotEmpty ? false : true,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          HorizontalLine(width: 100),
                          Text(
                            'Or',
                            style: TextStyle(fontSize: AppDefaults.fontSize),
                          ),
                          HorizontalLine(width: 100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(fontSize: AppDefaults.fontSize),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                              },
                              child: const Text(
                                'Login',
                                style:
                                    TextStyle(fontSize: AppDefaults.fontSize),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
