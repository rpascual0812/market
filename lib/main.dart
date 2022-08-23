import 'package:flutter/material.dart';
import 'package:market/screens/approot/app_root.dart';
import 'package:market/screens/auth/sign_up_page.dart';
import 'package:market/screens/profile/profile_page.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'screens/onboarding/onboarding_page.dart';

// void main() {
//   runApp(const MyApp());
// }
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hippos',
      theme: AppTheme(context).lightTheme,
      home: const AppRoot(),
    );
  }
}
