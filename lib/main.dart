import 'package:flutter/material.dart';
import 'package:market/screens/auth/login_page.dart';
import 'theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() {
//   runApp(const MyApp());
// }
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      title: 'Samdhana Community Market',
      theme: AppTheme(context).lightTheme,
      // home: const OnboardingPage(),
      home: const LoginPage(),
    );
  }
}
