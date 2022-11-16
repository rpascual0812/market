import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:market/components/cards/big/big_card_image.dart';
import 'package:market/components/sliders/home_slider.dart';
// import 'package:market/demo_data.dart';
import 'package:market/screens/future_crops/future_crops_widget.dart';
import 'package:market/screens/home/components/home_header.dart';
import 'package:market/screens/home/components/product_list.dart';
import 'package:market/screens/looking_for/looking_for_widget.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
import 'package:market/size_config.dart';

import '../../constants/app_defaults.dart';
import 'components/article_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.backButton,
  }) : super(key: key);

  final Widget? backButton;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Future<List<String>> getNextPageData(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    if (page == 3) return [];
    final items = List<String>.generate(20, (i) => "Item $i Page $page");
    return items;
  }

  List<String> data = [];
  bool everyThingLoaded = false;

  List products = [];
  List categories = [];
  int intialIndex = 0;
  int page = 0;

  @override
  void initState() {
    super.initState();
    loadInitialData();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        print('end of file');
        setState(() {
          page++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(backButton: widget.backButton),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: HomeSlider(),
            ),
            const SizedBox(height: AppDefaults.margin / 2),
            // const TitleAndSubtitle(),
            // const SizedBox(height: AppDefaults.margin / 2),
            // const SearchBar(),
            // const SizedBox(height: AppDefaults.margin),
            const ArticleList(),
            const SizedBox(height: AppDefaults.margin),
            const FutureCropsWidget(),
            const SizedBox(height: AppDefaults.margin),
            const LookingForWidget(),
            const SizedBox(height: AppDefaults.margin),
            // const ProductListWidget(),
            ProductList(page: page),
            // InfiniteScrollGrid(
            //   shrinkWrap: true,
            //   physics: const BouncingScrollPhysics(),
            //   padding: const EdgeInsets.all(10),
            //   crossAxisSpacing: 10,
            //   mainAxisSpacing: 10,
            //   onLoadingStart: (page) async {
            //     print(page);
            //     List<String> newData = await getNextPageData(page);
            //     setState(() {
            //       data += newData;
            //       if (newData.isEmpty) {
            //         everyThingLoaded = true;
            //       }
            //     });
            //   },
            //   everythingLoaded: everyThingLoaded,
            //   crossAxisCount: 2,
            //   children: data
            //       .map(
            //         (e) => GridItem(text: e),
            //       )
            //       .toList(),
            // ),
            // const SizedBox(height: AppDefaults.margin / 2),
          ],
        ),
      ),
    );
  }

  Future<void> loadInitialData() async {
    data = await getNextPageData(0);
    setState(() {});
  }
}

class GridItem extends StatelessWidget {
  final String text;
  const GridItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.3),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const CircleAvatar(
              child: Icon(Icons.image),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
