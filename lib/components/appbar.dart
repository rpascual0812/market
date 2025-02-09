import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/constants/app_icons.dart';
import 'package:market/screens/notifications/notification_page.dart';
import 'package:market/screens/product/components/cart_page.dart';
import 'package:market/screens/search/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  const Appbar({super.key, this.module = 'home'});

  final String module;

  @override
  State<Appbar> createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _AppbarState extends State<Appbar> {
  final storage = const FlutterSecureStorage();
  String? token = '';

  bool headerGuide = false;

  // Guide
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey searchKey = GlobalKey();
  GlobalKey cartKey = GlobalKey();
  GlobalKey notificationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getHeaderGuide();
    readStorage();

    createTutorial();
    // Future.delayed(Duration.zero, showTutorial);
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
    });
  }

  Future getHeaderGuide() async {
    final prefs = await SharedPreferences.getInstance();

    headerGuide = prefs.getBool('headerGuide') ?? false;

    if (!headerGuide) {
      Future.delayed(Duration.zero, showTutorial);
    }
  }

  Future setHeaderGuide() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('headerGuide', true);
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black12,
      textSkip: "",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        setHeaderGuide();
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
      // onSkip: () {
      //   setHeaderGuide();
      //   print("skip");
      // },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "searchKey",
        keyTarget: searchKey,
        alignSkip: Alignment.bottomLeft,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            align: ContentAlign.bottom,
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
                              "1",
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
                            "Search what crops you are looking for",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize + 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "cartKey",
        keyTarget: cartKey,
        alignSkip: Alignment.bottomLeft,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            align: ContentAlign.bottom,
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
                              "2",
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
                            "Manage your cart here",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize + 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "notificationKey",
        keyTarget: notificationKey,
        alignSkip: Alignment.bottomLeft,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            align: ContentAlign.bottom,
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
                              "3",
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
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            "Always check your notifications to be notified on upcoming news and update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize + 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => AppRoot(jwt: token ?? ''),
              //   ),
              // );
            },
            child: Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const AppRoot(jwt: ''),
              //   ),
              // );
            },
            child: const Text(
              'Lambo Mag-uuma',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          )
        ],
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [
            Visibility(
              visible: showHide(),
              child: IconButton(
                key: searchKey,
                padding: const EdgeInsets.only(left: 10),
                constraints: const BoxConstraints(),
                icon: AppIcons.searchWhite,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SearchPage();
                      },
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(width: 0),
            Visibility(
              visible: showHide(),
              child: IconButton(
                key: cartKey,
                padding: const EdgeInsets.only(left: 10),
                constraints: const BoxConstraints(),
                icon: AppIcons.shoppingBagWhite,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CartPage();
                      },
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: showHide(),
              child: IconButton(
                key: notificationKey,
                padding: const EdgeInsets.only(left: 10, right: 10),
                constraints: const BoxConstraints(),
                icon: AppIcons.bellWhite,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const NotificationPage();
                      },
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(width: 10),
          ],
        )
      ],
    );
  }

  showHide() {
    switch (widget.module) {
      case 'signin':
        {
          return false;
        }
      default:
        {
          return true;
        }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
