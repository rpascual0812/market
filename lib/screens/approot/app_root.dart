// import 'dart:html';

import 'dart:convert';

import 'package:flutter_svg/svg.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';

import 'package:http/http.dart' as http;

import '../auth/login_page.dart';
import '../chat/chat_page.dart';
import '../product_list/product_list_page.dart';
import '../profile/profile_page.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({
    Key? key,
    required this.jwt,
    this.menuIndex = 0,
    this.subIndex = 0,
    // this.backButton,
  }) : super(key: key);

  final String jwt;
  final int menuIndex;
  final int subIndex;
  // final Widget? backButton;
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool headerGuide = false;
  bool menuGuide = false;

  late List<Widget> _allScreen = [];
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData chatBold =
      IconData(0xe805, fontFamily: 'Custom', fontPackage: null);
  Map<String, dynamic> account = {};

  // Guide
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey homeKey = GlobalKey();
  GlobalKey productListKey = GlobalKey();
  GlobalKey chatKey = GlobalKey();
  GlobalKey profileKey = GlobalKey();

  @override
  void initState() {
    // print('sub index ${widget.menuIndex}');
    var token = AppDefaults.jwtDecode(widget.jwt);

    super.initState();

    getHeaderGuide();

    // print('approot ${widget.jwt}');
    _allScreen = [
      const HomePage(),
      ProductListPage(index: widget.subIndex),
      widget.jwt != '' ? const ChatPage() : const LoginPage(),
      widget.jwt != '' ? ProfilePage(token: widget.jwt) : const LoginPage(),
    ];

    if (token != null) {
      fetchUser(token['sub']);
    }

    updateMenu(widget.menuIndex);

    createTutorial();
    // Future.delayed(Duration.zero, showTutorial);
  }

  int _currentIndex = 0;

  void updateMenu(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future getHeaderGuide() async {
    final prefs = await SharedPreferences.getInstance();

    headerGuide = prefs.getBool('headerGuide') ?? false;

    getMenuGuide();
    // if (headerGuide) {
    //   Future.delayed(Duration.zero, showTutorial);
    // }
  }

  Future getMenuGuide() async {
    final prefs = await SharedPreferences.getInstance();

    menuGuide = prefs.getBool('menuGuide') ?? false;

    if (headerGuide && !menuGuide) {
      Future.delayed(Duration.zero, showTutorial);
    }
  }

  Future setMenuGuide() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('menuGuide', true);
  }

  Future fetchUser(int pk) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$pk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.jwt}',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          account = json.decode(res.body);
          // print(account);
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the market?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'No',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Yes',
            style: TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: AppColors.primary,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        setMenuGuide();
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        setMenuGuide();
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "homeKey",
        keyTarget: homeKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    height: 80.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 45,
                          width: 45,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const InkWell(
                            child: Text(
                              "4",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            "Home Page",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize + 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "productListKey",
        keyTarget: productListKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 80.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 45,
                          width: 45,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const InkWell(
                            child: Text(
                              "5",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            softWrap: false,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            "Tap to see updates from producers about their future crops, and from consumers about the products they are looking for.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "chatKey",
        keyTarget: chatKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 80.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 45,
                          width: 45,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const InkWell(
                            child: Text(
                              "6",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            softWrap: false,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            "Messages for your future transactions with other users",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize + 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "profileKey",
        keyTarget: profileKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 80.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 45,
                          width: 45,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const InkWell(
                            child: Text(
                              "7",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            softWrap: false,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            "Profile Page",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize + 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (account['user'] != null) {
      userImage = AppDefaults.userImage(account['user']['user_document']);
    }
    // var userImage = AppDefaults.userImage(account['user']['user_document']);
    // print('approot');
    // print(widget.jwt);
    // final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        // backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,

        /// Returns Page With Animation
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation, secondAnimation) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          child: _allScreen[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: updateMenu,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 28,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: const Color(0xFFD0D0D0),
          items: [
            BottomNavigationBarItem(
              label: "",
              icon: _currentIndex == 0
                  ? SvgPicture.asset('assets/icons/home-selected.svg',
                      color: AppColors.primary, width: 30, key: homeKey)
                  : SvgPicture.asset('assets/icons/home.svg',
                      color: AppColors.secondary, width: 30, key: homeKey),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: _currentIndex == 1
                  ? SvgPicture.asset('assets/icons/newspaper-selected.svg',
                      color: AppColors.primary, width: 30, key: productListKey)
                  : SvgPicture.asset('assets/icons/newspaper.svg',
                      color: AppColors.secondary,
                      width: 30,
                      key: productListKey),
            ),
            // BottomNavigationBarItem(
            //   label: "",
            //   icon: Icon(_currentIndex == 0
            //       ? IconlyBold.notification
            //       : IconlyLight.notification),
            // ),
            BottomNavigationBarItem(
              label: "",
              icon: _currentIndex == 2
                  ? SvgPicture.asset(
                      'assets/icons/messenger-white.svg',
                      color: AppColors.primary,
                      width: 30,
                      key: chatKey,
                    )
                  : SvgPicture.asset(
                      'assets/icons/messenger-white.svg',
                      color: AppColors.secondary,
                      width: 30,
                      key: chatKey,
                    ),
            ),

            BottomNavigationBarItem(
              label: "",
              icon: widget.jwt != ''
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(userImage),
                      radius: AppDefaults.radius,
                      key: profileKey,
                    )
                  : Icon(
                      key: profileKey,
                      _currentIndex == 3
                          ? IconlyBold.profile
                          : IconlyLight.profile,
                      color: _currentIndex == 3
                          ? AppColors.primary
                          : AppColors.secondary,
                      size: 30,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
