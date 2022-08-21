// import 'dart:html';

import 'package:animations/animations.dart';
import 'package:market/screens/home/home_page.dart';
import 'package:market/screens/notifications/notification_page.dart';
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
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late List<Widget> _allScreen = [];

  @override
  void initState() {
    super.initState();
    _allScreen = [
      const NotificationPage(),
      const ProductListPage(),
      const HomePage(),
      const ProfilePage(),
    ];
  }

  int _currentIndex = 2;

  void updateMenu(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,

      /// Returns Page With Animation
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation, secondAnimation) {
          return SharedAxisTransition(
            child: child,
            animation: animation,
            secondaryAnimation: secondAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
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
            icon: Icon(_currentIndex == 0
                ? IconlyBold.notification
                : IconlyLight.notification),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(_currentIndex == 1
                ? IconlyBold.document
                : IconlyLight.document),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(_currentIndex == 2 ? IconlyBold.home : IconlyLight.home),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
                _currentIndex == 3 ? IconlyBold.profile : IconlyLight.profile),
          ),
        ],
      ),
    );
  }
}
