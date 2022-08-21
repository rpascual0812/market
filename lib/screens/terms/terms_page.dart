// import 'dart:html';

import 'package:animations/animations.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/home/home_page.dart';
import 'package:market/screens/notifications/notification_page.dart';
import 'package:market/screens/product_list/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../constants/app_colors.dart';
import '../profile/profile_page.dart';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({
    Key? key,
    // this.backButton,
  }) : super(key: key);

  // final Widget? backButton;
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Appbar(),
                Accordion(
                  maxOpenSections: 1,
                  headerBackgroundColorOpened: Colors.black54,
                  scaleWhenAnimating: true,
                  openAndCloseAnimation: true,
                  headerPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                  sectionClosingHapticFeedback: SectionHapticFeedback.light,
                  children: [
                    AccordionSection(
                      isOpen: true,
                      // leftIcon: const Icon(Icons.insights_rounded,
                      //     color: Colors.white),
                      headerBackgroundColor: AppColors.primary,
                      headerBackgroundColorOpened: AppColors.primary,
                      header: Text('Disclaimer', style: _headerStyle),
                      content: Text(_loremIpsum, style: _contentStyle),
                      contentHorizontalPadding: 20,
                      contentBorderWidth: 1,
                      // onOpenSection: () => print('onOpenSection ...'),
                      // onCloseSection: () => print('onCloseSection ...'),
                    ),
                    AccordionSection(
                      isOpen: true,
                      // leftIcon: const Icon(Icons.insights_rounded,
                      //     color: Colors.white),
                      headerBackgroundColor: AppColors.primary,
                      headerBackgroundColorOpened: AppColors.primary,
                      header: Text('Legal Conditions', style: _headerStyle),
                      content: Text(_loremIpsum, style: _contentStyle),
                      contentHorizontalPadding: 20,
                      contentBorderWidth: 1,
                      // onOpenSection: () => print('onOpenSection ...'),
                      // onCloseSection: () => print('onCloseSection ...'),
                    ),
                    AccordionSection(
                      isOpen: true,
                      // leftIcon: const Icon(Icons.insights_rounded,
                      //     color: Colors.white),
                      headerBackgroundColor: AppColors.primary,
                      headerBackgroundColorOpened: AppColors.primary,
                      header: Text('Terms and Conditions', style: _headerStyle),
                      content: Text(_loremIpsum, style: _contentStyle),
                      contentHorizontalPadding: 20,
                      contentBorderWidth: 1,
                      // onOpenSection: () => print('onOpenSection ...'),
                      // onCloseSection: () => print('onCloseSection ...'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
