import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constants/index.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  await dotenv.load();
}

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({
    Key? key,
    required this.code,
    required this.callback,
  }) : super(key: key);

  final String code;
  final void Function(bool)? callback;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  bool hasError = false;

  final passwordController = TextEditingController(text: '');
  final confirmPasswordController = TextEditingController(text: '');
  String errorMessage = '';
  bool isLoading = false;
  bool sent = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();
    super.dispose();
  }

  Future submit() async {
    if (_key.currentState!.validate()) {
      try {
        var res = await http
            .post(Uri.parse('${dotenv.get('API')}/reset-password'), body: {
          "token": widget.code,
          "password": passwordController.text,
        });

        if (res.statusCode == 200) {
          widget.callback!(true);
        }

        return null;
      } on Exception {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Form(
        key: _key,
        child: Column(
          children: [
            const SizedBox(height: AppDefaults.margin * 3),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDefaults.fontSize,
                ),
              ),
            ),
            const SizedBox(height: AppDefaults.margin / 2),
            SizedBox(
              height: AppDefaults.height + 50,
              // padding: EdgeInsets.zero,
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                validator: validatePassword,
                decoration: InputDecoration(
                  helperText: ' ',
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  focusedBorder: AppDefaults.outlineInputBorderSuccess,
                  enabledBorder: AppDefaults.outlineInputBorderSuccess,
                  focusedErrorBorder: AppDefaults.outlineInputBorderError,
                  errorBorder: AppDefaults.outlineInputBorderError,
                ),
                style: const TextStyle(fontSize: 14), // <-- SEE HERE
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Confirm Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDefaults.fontSize,
                ),
              ),
            ),
            const SizedBox(height: AppDefaults.margin / 2),
            SizedBox(
              height: AppDefaults.height + 20,
              // padding: EdgeInsets.zero,
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Confirm password is required';
                  }
                  if (value != passwordController.text) {
                    return 'Confirm password does not match';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  helperText: ' ',
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  focusedBorder: AppDefaults.outlineInputBorderSuccess,
                  enabledBorder: AppDefaults.outlineInputBorderSuccess,
                  focusedErrorBorder: AppDefaults.outlineInputBorderError,
                  errorBorder: AppDefaults.outlineInputBorderError,
                ),
                style: const TextStyle(fontSize: 14), // <-- SEE HERE
              ),
            ),
            const SizedBox(height: AppDefaults.margin / 2),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: AppDefaults.height,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: ElevatedButton(
                  onPressed: () async {
                    await submit();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDefaults.radius - 10),
                    ),
                  ),
                  child: const Text('Reset Password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(errorMessage,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required.';
  }

  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return '''
      Password must be at least 8 characters,
      include an uppercase letter and a number.
      ''';
  }

  return null;
}
