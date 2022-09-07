import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/app_colors.dart';

import 'package:market/models/product.dart';
import 'package:market/screens/looking_for/looking_for_page_tile.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool isLoading = false;

  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  // final _contentStyleHeader = const TextStyle(
  //     color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();

    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Recently viewed Products',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                  header: Text('Question 1', style: _headerStyle),
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
                  header: Text('Question 2', style: _headerStyle),
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
                  header: Text('Question 3', style: _headerStyle),
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
    );
  }
}
