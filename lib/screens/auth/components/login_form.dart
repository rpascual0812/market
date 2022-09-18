import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/screens/approot/app_root.dart';
// import 'package:market/screens/approot/app_root.dart';
// import 'package:provider/provider.dart';

import '../../../components/icon_with_background.dart';
import '../../../constants/index.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    var res = await http.post(Uri.parse('${dotenv.get('API')}/login'),
        body: {"username": username, "password": password});
    if (res.statusCode == 200) return res.body;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Form(
        key: _key,
        child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              validator: validateEmail,
              decoration: const InputDecoration(
                prefixIcon: IconWithBackground(iconData: IconlyBold.message),
                labelText: 'Email',
                hintText: 'email@gmail.com',
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            TextFormField(
              controller: passwordController,
              // validator: validatePassword,
              decoration: const InputDecoration(
                prefixIcon: IconWithBackground(iconData: IconlyBold.lock),
                labelText: 'Password',
                hintText: '*********',
              ),
            ), // Forgot Password Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                  )),
            ),

            /// Login Button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () async {
                  var username = usernameController.text;
                  var password = passwordController.text;
                  var jwt = await attemptLogIn(username, password);
                  if (jwt != null) {
                    storage.write(key: "jwt", value: jwt);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppRoot(jwt: jwt),
                      ),
                    );
                  } else {
                    AppDefaults.displayDialog(context, "An Error Occurred",
                        "No account was found matching that username and password");
                  }

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const AppRoot(),
                  //   ),
                  // );
                },
                child: const Text('Log In'),
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
