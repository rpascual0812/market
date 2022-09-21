import 'package:flutter/material.dart';
// import 'package:market/screens/approot/app_root.dart';
// import 'package:provider/provider.dart';

import '../../../constants/index.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../approot/app_root.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  await dotenv.load();
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController(text: 'email@gmail.com');
  final passwordController = TextEditingController(text: 'password');
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  Future attemptLogIn(String username, String password) async {
    try {
      print(dotenv.get('API'));
      var res = await http.post(Uri.parse('${dotenv.get('API')}/login'),
          body: {"username": username, "password": password});
      if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      return null;
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
            const SizedBox(
              height: AppDefaults.margin / 2,
            ),
            SizedBox(
              height: AppDefaults.height,
              // padding: EdgeInsets.zero,
              child: TextFormField(
                controller: usernameController,
                validator: validateEmail,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10, right: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDefaults.radius),
                    borderSide: const BorderSide(width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDefaults.radius),
                    borderSide: const BorderSide(width: 1.0),
                  ),
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
            const SizedBox(
              height: AppDefaults.margin / 2,
            ),
            SizedBox(
              height: 40,
              // padding: EdgeInsets.zero,
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                validator: validatePassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10, right: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDefaults.radius),
                    borderSide: const BorderSide(width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDefaults.radius),
                    borderSide: const BorderSide(width: 1.0),
                  ),
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
                  onPressed: () {},
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
                    var username = usernameController.text;
                    var password = passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    if (jwt != null) {
                      storage.write(key: "jwt", value: jwt);
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppRoot(jwt: jwt),
                        ),
                      );
                    } else {
                      if (!mounted) return;
                      AppDefaults.displayDialog(context, "An Error Occurred",
                          "No account was found matching that username and password");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDefaults.radius),
                    ),
                  ),
                  child: const Text('Log In'),
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
            //       var jwt = await attemptLogIn(username, password);
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
