import 'package:flutter/material.dart';

import '../../components/horizontal_line.dart';
import '../../constants/index.dart';
import 'components/signup_form.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

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
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        HorizontalLine(width: 100),
                        Text('Or'),
                        HorizontalLine(width: 100),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                            },
                            child: const Text('Login'))
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
