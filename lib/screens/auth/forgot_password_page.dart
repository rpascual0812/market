import 'package:flutter/material.dart';
import 'package:market/screens/auth/components/reset_password_form.dart';
import 'package:market/screens/auth/components/send_code_form.dart';
import 'package:market/screens/auth/components/validate_code_form.dart';

import '../../components/horizontal_line.dart';
import '../../constants/index.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool codeSent = false;
  String code = '';
  String email_address = '';
  bool validated = false;

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
                        "   Forgot Password",
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
              Visibility(
                visible: !codeSent,
                child: SendCodeForm(callback: (data) {
                  setState(() {
                    code = data['data']['token'];
                    email_address = data['data']['email_address'];
                    codeSent = data['status'];
                  });
                }),
              ),
              Visibility(
                visible: code.isNotEmpty && !validated,
                child: ValidateCodeForm(
                    code: code,
                    callback: (status) {
                      setState(() {
                        validated = true;
                      });
                    }),
              ),
              Visibility(
                visible: validated,
                child: ResetPasswordForm(
                    code: code,
                    callback: (status) {
                      setState(() {
                        if (status) {
                          AppDefaults.toast(context, 'success',
                              AppMessage.getSuccess('PASSWORD_RESET'));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                        }
                      });
                    }),
              ),
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
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              'Go back',
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
