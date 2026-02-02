import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:market/db/market_db.dart';
import 'package:market/models/config.dart';
import 'package:market/screens/auth/forgot_password_page.dart';
import '../../../components/custom_animation.dart';
import '../../../constants/index.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../approot/app_root.dart';

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
    ..maskColor = Colors.blue.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();
    super.dispose();
  }

  Future submit(String username, String password) async {
    try {
      var res = await http.post(Uri.parse('${dotenv.get('API')}/login'), body: {
        "username": username,
        "password": password,
        'role': 'end-user'
      });
      if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _key,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDefaults.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: AppDefaults.margin / 2),
              SizedBox(
                height: AppDefaults.height,
                // padding: EdgeInsets.zero,
                child: TextFormField(
                  controller: usernameController,
                  validator: validateEmail,
                  decoration: InputDecoration(
                    // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    focusedBorder: AppDefaults.outlineInputBorderSuccess,
                    enabledBorder: AppDefaults.outlineInputBorderSuccess,
                  ),
                  style: const TextStyle(
                      fontSize: AppDefaults.fontSize), // <-- SEE HERE
                ),
              ),
              // TextFormField(
              //   controller: usernameController,
              //   validator: validateEmail,
              //   decoration: const InputDecoration(
              //     prefixIcon: IconWithBackground(iconData: IconlyBold.message),
              //     labelText: 'Email',
              //     hintText: 'email@gmail.com',
              //   ),
              // ),
              const SizedBox(height: AppDefaults.margin),
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
                height: AppDefaults.height,
                // padding: EdgeInsets.zero,
                child: TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                  validator: validatePassword,
                  decoration: InputDecoration(
                    // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    focusedBorder: AppDefaults.outlineInputBorderSuccess,
                    enabledBorder: AppDefaults.outlineInputBorderSuccess,
                  ),
                  style: const TextStyle(fontSize: 14), // <-- SEE HERE
                ),
              ),
              // TextFormField(
              //   controller: passwordController,
              //   // validator: validatePassword,
              //   decoration: const InputDecoration(
              //     prefixIcon: IconWithBackground(iconData: IconlyBold.lock),
              //     labelText: 'Password',
              //     hintText: '*********',
              //   ),
              // ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: AppDefaults.fontSize,
                      ),
                    )),
              ),

              /// Login Button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: AppDefaults.height,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () async {
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.clear,
                      );

                      var username = usernameController.text;
                      var password = passwordController.text;
                      var result = await submit(username, password);
                      // print(result);
                      if (result != null) {
                        var jwtJson = jsonDecode(result);
                        var jwt = jwtJson['user']['access_token'];

                        await MarketDatabase.instance
                            .create(Config(key: 'jwt', value: jwt));

                        storage.write(key: "jwt", value: jwt);
                        if (jwtJson['user']['seller_pk'] != '0') {
                          storage.write(
                            key: "producer",
                            value: jwtJson['user']['seller_pk'].toString(),
                          );
                        }
                        if (!mounted) return;

                        // AppDefaults.toast(context, 'success',
                        //     AppMessage.getSuccess('LOGIN_SUCCESS'));

                        // Fluttertoast.showToast(
                        //   msg: "Please wait while we are fetching your account.",
                        //   toastLength: Toast.LENGTH_SHORT,
                        //   gravity: ToastGravity.BOTTOM,
                        //   timeInSecForIosWeb: 1,
                        //   backgroundColor: AppColors.primary,
                        //   textColor: Colors.white,
                        //   fontSize: 12.0,
                        // );
                        EasyLoading.dismiss();
                        AppDefaults.navigate(context, AppRoot(jwt: jwt ?? ''));
                        // Timer(
                        //   const Duration(seconds: 1),
                        //   () => {
                        //     AppDefaults.navigate(context, AppRoot(jwt: jwt))
                        //     // Navigator.push(
                        //     //   context,
                        //     //   MaterialPageRoute(
                        //     //     builder: (context) => AppRoot(jwt: jwt),
                        //     //   ),
                        //     // )
                        //   },
                        // );
                      } else {
                        if (!mounted) return;
                        // AppDefaults.displayDialog(context, "An Error Occurred",
                        //     "No account was found matching that username and password");
                        EasyLoading.dismiss();
                        AppDefaults.toast(context, 'error',
                            AppMessage.getError('ERROR_USER_NOT_FOUND'));

                        // var jwt =
                        //     '{"status":"success","user":{"username":"email@gmail.com","access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiZW1haWxAZ21haWwuY29tIiwic3ViIjoxMTMsImlhdCI6MTY2NDAwNDA4MCwiZXhwIjoxNjY0MDQ3MjgwfQ.c8oXPKGkFgKJn_ljz1vdrIQ-lOe2SnFZFiA6mmEVdpI","expiration":"2023-09-25 03:21:20"}}';
                        // Timer(
                        //   const Duration(seconds: 1),
                        //   () => {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => AppRoot(jwt: jwt),
                        //       ),
                        //     )
                        //   },
                        // );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDefaults.radius - 10),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                          fontSize: AppDefaults.fontSize, color: Colors.white),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: AppDefaults.height,
              //   width: MediaQuery.of(context).size.width * 0.4,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       var username = usernameController.text;
              //       var password = passwordController.text;
              //       var jwt = await submit(username, password);
              //       if (jwt != null) {
              //         storage.write(key: "jwt", value: jwt);
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => AppRoot(jwt: jwt),
              //           ),
              //         );
              //       } else {
              //         AppDefaults.displayDialog(context, "An Error Occurred",
              //             "No account was found matching that username and password");
              //       }

              //       // Navigator.of(context).push(
              //       //   MaterialPageRoute(
              //       //     builder: (context) => const AppRoot(),
              //       //   ),
              //       // );
              //     },
              //     style: ButtonStyle(
              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(AppDefaults.radius),
              //         ),
              //       ),
              //     ),
              //     child: const Padding(
              //       padding: EdgeInsets.only(left: 10, right: 10),
              //       child: Text(
              //         'Log In',
              //         style: TextStyle(fontSize: AppDefaults.fontSize),
              //       ),
              //     ),
              //     // child: const Text(
              //     //   'Log In',
              //     //   style: TextStyle(fontSize: AppDefaults.fontSize),
              //     // ),
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
      include an uppercase letter, number and symbol.
      ''';
  }

  return null;
}
