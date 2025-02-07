import 'package:flutter/material.dart';
import 'package:market/screens/approot/app_root.dart';
import 'package:market/screens/onboarding/onboarding_page.dart';
import 'theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  const MyApp({super.key});

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
      welcome = welcomeStorage ?? '';
      jwt = jwtStorage ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    readStorage();

    return MaterialApp(
      // showPerformanceOverlay: true,
      title: 'LAMBO MAG-UUMA',
      // theme: AppTheme(context).lightTheme,
      home: welcome != ''
          ? AppRoot(jwt: jwt)
          : OnboardingPage(
              jwt: jwt,
            ),
      // home: OnboardingPage(jwt: jwt),
      builder: EasyLoading.init(),
    );
  }
}
