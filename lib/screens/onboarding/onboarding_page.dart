import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/screens/approot/app_root.dart';
import 'package:market/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/onboarding_content_view.dart';
import 'data/onboarding_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    Key? key,
    required this.jwt,
  }) : super(key: key);

  final String jwt;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  int currentPage = 0;
  List boards = [];
  Map<Object, dynamic> dataJson = {};

  /// When the next button is pressed if we are on first page we will go to second
  /// page, otherwise we will go to login page
  void _onNextButtonPressed() {
    if (currentPage + 1 == boards.length) {
      _goToLoginPage();
    } else {
      int newPage = currentPage + 1;
      _pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
    setState(() {});
  }

  void _goToLoginPage() {
    setSkipOnboarding();

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AppRoot(jwt: '')));
  }

  @override
  void initState() {
    fetch();

    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future setSkipOnboarding() async {
    storage.write(key: "welcome", value: 'true');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('hideOnboarding', 1);
    // int? hideOnboarding = preferences.getInt('hideOnboarding');
    // print('hideOnboarding ' + hideOnboarding.toString());
  }

  Future<void> fetch() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/onboardings');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.jwt}',
      };

      var res = await http.get(
        url,
        headers: headers,
      );

      if (res.statusCode == 200) {
        dataJson = jsonDecode(res.body);
        boards = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          boards.add(dataJson['data'][i]);
        }
      }
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Active Page
              Text(
                '${currentPage + 1}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // Total Pages
              Text(
                '/${OnboardingData.boards.length}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _goToLoginPage,
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),

      /// Next button is inside [OnboardingContentView] widget
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Image
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, index) {
                return OnboardingContentView(
                  board: boards[index],
                  currentIndex: index,
                  onNext: _onNextButtonPressed,
                );
              },
              onPageChanged: (v) {
                currentPage = v;
                setState(() {});
              },
              controller: _pageController,
              itemCount: boards.length,
            ),
          ),
        ],
      ),
    );
  }
}
