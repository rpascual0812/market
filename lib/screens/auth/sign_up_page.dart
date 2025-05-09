import 'package:flutter/material.dart';

import '../../components/horizontal_line.dart';
import '../../constants/index.dart';
import 'components/signup_form.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({
    super.key,
  });

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
                child: const Column(
                  children: [
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
              const SignUpForm(),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                              style: TextStyle(fontSize: AppDefaults.fontSize),
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
