// import 'dart:html';

import 'package:animations/animations.dart';
import 'package:market/screens/chat/chat_page.dart';
import 'package:market/screens/home/home_page.dart';
import 'package:market/screens/product_list/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../constants/app_colors.dart';
import '../profile/profile_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({
    Key? key,
    // this.backButton,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _allScreen = [
      const HomePage(),
      const ProductListPage(),
      const ChatPage(),
      const ProfilePage(),
    ];
  }

  int _currentIndex = 0;

  void updateMenu(int index) {
    setState(() {
      _currentIndex = index;
    });
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
              icon: Icon(_currentIndex == 3
                  ? IconlyBold.profile
                  : IconlyLight.profile),
            ),
          ],
        ),
      ),
    );
  }
}
