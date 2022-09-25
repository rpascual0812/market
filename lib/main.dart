import 'package:flutter/material.dart';
import 'package:market/screens/approot/app_root.dart';
import 'package:market/screens/onboarding/onboarding_page.dart';
import 'theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

// void main() {
//   runApp(const MyApp());
// }
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String welcome = '';
  String jwt = '';

  Future<void> readStorage() async {
    final welcomeStorage = await storage.read(key: 'welcome');
    final jwtStorage = await storage.read(key: 'jwt');

    setState(() {
      welcome = welcomeStorage!;
      jwt = jwtStorage!;
    });
  }

  @override
  Widget build(BuildContext context) {
    readStorage();

    return MaterialApp(
      // showPerformanceOverlay: true,
      title: 'Samdhana Community Market',
      theme: AppTheme(context).lightTheme,
      home: welcome != '' ? AppRoot(jwt: jwt) : const OnboardingPage(),
    );
  }
}
