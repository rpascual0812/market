import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../components/custom_animation.dart';
import '../../../constants/index.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  await dotenv.load();
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class SendCodeForm extends StatefulWidget {
  const SendCodeForm({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final void Function(Map<String, dynamic>)? callback;

  @override
  State<SendCodeForm> createState() => _SendCodeFormState();
}

class _SendCodeFormState extends State<SendCodeForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController(text: '');
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
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.clear,
        );

        var res = await http
            .post(Uri.parse('${dotenv.get('API')}/forgot-password'), body: {
          "email": emailController.text,
          "device": 'mobile',
          "url": '',
        });
        // print(res.statusCode);
        if (res.statusCode == 200) {
          var data = json.decode(res.body);

          EasyLoading.dismiss();
          if (!mounted) return;
          AppDefaults.toast(
              context, 'success', AppMessage.getSuccess('EMAIL_SENT'));
          widget.callback!({
            'status': true,
            'data': {
              'email_address': emailController.text,
              'token': data['data']['password_reset']['token']
            }
          });
        } else {
          if (!mounted) return;
          AppDefaults.toast(
              context, 'error', AppMessage.getError('EMAIL_NOT_FOUND'));
        }

        EasyLoading.dismiss();
        return null;
      } on Exception {
        EasyLoading.dismiss();
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
                'To reset your password, a 4-digit code will be sent to your registered Email Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDefaults.fontSize,
                ),
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            SizedBox(
              height: AppDefaults.height + 20,
              // padding: EdgeInsets.zero,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
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
                style: AppDefaults.formTextStyle,
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
                  child: const Text('Send Code'),
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

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}
