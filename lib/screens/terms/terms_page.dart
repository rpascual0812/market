// import 'dart:html';

import 'package:animations/animations.dart';
import 'package:market/components/appbar.dart';
import 'package:flutter/material.dart';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

import '../../constants/index.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({
    Key? key,
    // this.backButton,
  }) : super(key: key);

  // final Widget? backButton;
  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final _contentStyle = const TextStyle(
      color: Colors.black,
      fontSize: AppDefaults.fontSize,
      fontWeight: FontWeight.normal);
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
            animation: animation,
            secondaryAnimation: secondAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Appbar(),
                Accordion(
                  headerBorderRadius: 10,
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
                      headerBackgroundColor: Colors.white,
                      headerBackgroundColorOpened: AppColors.primary,
                      header: const Text('Disclaimer'),
                      content: Text(_loremIpsum, style: _contentStyle),
                      contentHorizontalPadding: 20,
                      contentBorderColor: AppColors.primary,
                    ),
                    AccordionSection(
                      isOpen: false,
                      headerBackgroundColor: Colors.white,
                      headerBackgroundColorOpened: AppColors.primary,
                      header: const Text('Legal Conditions'),
                      content: Text(_loremIpsum, style: _contentStyle),
                      contentHorizontalPadding: 20,
                      contentBorderColor: AppColors.primary,
                    ),
                    AccordionSection(
                      isOpen: false,
                      headerBackgroundColor: Colors.white,
                      headerBackgroundColorOpened: AppColors.primary,
                      header: const Text('Terms and Conditions'),
                      content: Text(_loremIpsum, style: _contentStyle),
                      contentHorizontalPadding: 20,
                      contentBorderColor: AppColors.primary,
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: AppDefaults.height,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDefaults.radius - 10),
                        ),
                      ),
                      child: const Text('I Agree!'),
                    ),
                  ),
                ),
                // Accordion(
                //   maxOpenSections: 1,
                //   headerBackgroundColorOpened: Colors.black54,
                //   scaleWhenAnimating: true,
                //   openAndCloseAnimation: true,
                //   headerPadding:
                //       const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                //   sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                //   sectionClosingHapticFeedback: SectionHapticFeedback.light,
                //   children: [
                //     AccordionSection(
                //       isOpen: true,
                //       // leftIcon: const Icon(Icons.insights_rounded,
                //       //     color: Colors.white),
                //       headerBackgroundColor: AppColors.primary,
                //       headerBackgroundColorOpened: AppColors.primary,
                //       header: Text('Disclaimer', style: _headerStyle),
                //       content: Text(_loremIpsum, style: _contentStyle),
                //       contentHorizontalPadding: 20,
                //       contentBorderWidth: 1,
                //       // onOpenSection: () => print('onOpenSection ...'),
                //       // onCloseSection: () => print('onCloseSection ...'),
                //     ),
                //     AccordionSection(
                //       isOpen: true,
                //       // leftIcon: const Icon(Icons.insights_rounded,
                //       //     color: Colors.white),
                //       headerBackgroundColor: AppColors.primary,
                //       headerBackgroundColorOpened: AppColors.primary,
                //       header: Text('Legal Conditions', style: _headerStyle),
                //       content: Text(_loremIpsum, style: _contentStyle),
                //       contentHorizontalPadding: 20,
                //       contentBorderWidth: 1,
                //       // onOpenSection: () => print('onOpenSection ...'),
                //       // onCloseSection: () => print('onCloseSection ...'),
                //     ),
                //     AccordionSection(
                //       isOpen: true,
                //       // leftIcon: const Icon(Icons.insights_rounded,
                //       //     color: Colors.white),
                //       headerBackgroundColor: AppColors.primary,
                //       headerBackgroundColorOpened: AppColors.primary,
                //       header: Text('Terms and Conditions', style: _headerStyle),
                //       content: Text(_loremIpsum, style: _contentStyle),
                //       contentHorizontalPadding: 20,
                //       contentBorderWidth: 1,
                //       // onOpenSection: () => print('onOpenSection ...'),
                //       // onCloseSection: () => print('onCloseSection ...'),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
