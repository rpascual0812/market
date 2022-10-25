// import 'dart:html';

import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../constants/app_colors.dart';

import 'package:http/http.dart' as http;

import '../auth/login_page.dart';
import '../chat/chat_page.dart';
import '../product_list/product_list_page.dart';
import '../profile/profile_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key, required this.jwt
      // this.backButton,
      })
      : super(key: key);

  final String jwt;
  // final Widget? backButton;
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late List<Widget> _allScreen = [];
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData chatBold =
      IconData(0xe805, fontFamily: 'Custom', fontPackage: null);
  Map<String, dynamic> account = {};

  @override
  void initState() {
    var token = AppDefaults.jwtDecode(widget.jwt);

    super.initState();
    // print('approot ${widget.jwt}');
    _allScreen = [
      const HomePage(),
      const ProductListPage(),
      const ChatPage(),
      widget.jwt != '' ? ProfilePage(token: widget.jwt) : const LoginPage(),
    ];

    if (token != null) {
      fetchUser(token['sub']);
    }
  }

  int _currentIndex = 0;

  void updateMenu(int index) {
    setState(() {
      _currentIndex = index;
    });
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
          print(account);
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
              icon:
                  Icon(_currentIndex == 0 ? IconlyBold.home : IconlyLight.home),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Icon(_currentIndex == 1
                  ? IconlyBold.document
                  : IconlyLight.document),
            ),
            // BottomNavigationBarItem(
            //   label: "",
            //   icon: Icon(_currentIndex == 0
            //       ? IconlyBold.notification
            //       : IconlyLight.notification),
            // ),
            BottomNavigationBarItem(
              label: "",
              icon: Icon(_currentIndex == 2 ? chatBold : chat),
            ),

            BottomNavigationBarItem(
              label: "",
              icon: widget.jwt != ''
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(userImage),
                      radius: AppDefaults.radius,
                    )
                  : Icon(_currentIndex == 3
                      ? IconlyBold.profile
                      : IconlyLight.profile),
            ),
          ],
        ),
      ),
    );
  }
}
