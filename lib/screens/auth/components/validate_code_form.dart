import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constants/index.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  await dotenv.load();
}

class ValidateCodeForm extends StatefulWidget {
  const ValidateCodeForm({
    Key? key,
    required this.code,
    required this.callback,
  }) : super(key: key);

  final String code;
  final void Function(bool)? callback;

  @override
  State<ValidateCodeForm> createState() => _ValidateCodeFormState();
}

class _ValidateCodeFormState extends State<ValidateCodeForm> {
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

  Future submit(v) async {
    setState(() {
      if (widget.code != v) {
        hasError = true;
      } else {
        print(widget.code);
        print(v);
        print("Completed");
        widget.callback!(true);
      }
    });
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
            // const Align(
            //   alignment: Alignment.center,
            //   child: Text(
            //     '4-digit code',
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: AppDefaults.fontSize,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: AppDefaults.margin / 2),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: AppDefaults.height + 40,
              // padding: EdgeInsets.zero,23
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                length: 4,
                obscureText: false,
                obscuringCharacter: '*',
                animationType: AnimationType.fade,
                validator: (v) {
                  return null;
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(1),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeFillColor: hasError ? AppColors.danger : Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                textStyle: const TextStyle(fontSize: 20, height: 1.6),
                backgroundColor: Colors.white,
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (v) {
                  submit(v);
                },
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),
            // const SizedBox(height: AppDefaults.margin / 2),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.4,
            //   height: AppDefaults.height,
            //   child: Padding(
            //     padding: const EdgeInsets.all(1),
            //     child: ElevatedButton(
            //       onPressed: () async {
            //         await submit();
            //       },
            //       style: ElevatedButton.styleFrom(
            //         padding: const EdgeInsets.all(0),
            //         shape: RoundedRectangleBorder(
            //           borderRadius:
            //               BorderRadius.circular(AppDefaults.radius - 10),
            //         ),
            //       ),
            //       child: const Text('Validate'),
            //     ),
            //   ),
            // ),
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

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return '''
      Password must be at least 8 characters,
      include an uppercase letter and a number.
      ''';
  }

  return null;
}
