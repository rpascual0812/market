import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  List faqs = [];

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

  final headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  // final _contentStyleHeader = const TextStyle(
  //     color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });

    loadInitialData();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();

    super.dispose();
  }

  Future fetch() async {
    try {
      var res = await Remote.get('faq', {
        'skip': skip.toString(),
        'take': take.toString(),
      });

      if (res.statusCode == 200) {
        var dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (data.length <= take) {
          everyThingLoaded = true;
        }

        return data;
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  Future<void> loadInitialData() async {
    faqs = await getNextPageData(page);
    // print('load initial data $products');
    setState(() {});
  }

  Future getNextPageData(int page) async {
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      faqs += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        controller: _scrollController,
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
                          'Frequently Asked Questions',
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
            const SizedBox(height: 50),
            for (var faq in faqs)
              GFAccordion(
                title: faq['question'],
                content: faq['answer'],
                collapsedTitleBackgroundColor: Colors.white,
                expandedTitleBackgroundColor: AppColors.primary,
                titleBorder: Border.all(
                  color: const Color(0xFF000000),
                  width: 1,
                  style: BorderStyle.solid,
                ),
                titleBorderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Map<String, dynamic> faq;
  const ListItem({
    Key? key,
    required this.faq,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
        color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
    // final _contentStyleHeader = const TextStyle(
    //     color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
    const contentStyle = TextStyle(
        color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

    return Accordion(
      maxOpenSections: 0,
      headerBackgroundColorOpened: Colors.black54,
      scaleWhenAnimating: true,
      openAndCloseAnimation: false,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: [
        AccordionSection(
          isOpen: true,
          // leftIcon: const Icon(Icons.insights_rounded,
          //     color: Colors.white),
          headerBackgroundColor: AppColors.primary,
          headerBackgroundColorOpened: AppColors.primary,
          header: Text(faq['question'], style: headerStyle),
          content: Text(faq['answer'], style: contentStyle),
          contentHorizontalPadding: 20,
          contentBorderWidth: 1,
          // onOpenSection: () => print('onOpenSection ...'),
          // onCloseSection: () => print('onCloseSection ...'),
        ),
      ],
    );
  }
}
