import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll_grid.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/components/select_dropdown_obj.dart';
// import 'package:flutter/rendering.dart';
// import 'package:market/components/cards/big/big_card_image.dart';
import 'package:market/components/sliders/home_slider.dart';
import 'package:market/constants/index.dart';
// import 'package:market/demo_data.dart';
import 'package:market/screens/future_crops/future_crops_widget.dart';
import 'package:market/screens/home/components/home_header.dart';
import 'package:market/screens/looking_for/looking_for_widget.dart';
import 'package:market/screens/product/product_page.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
import 'package:market/size_config.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'components/article_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.backButton,
  });

  final Widget? backButton;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyBottomNavigation1 = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  int page = 0;

  List categories = [];
  List products = [];
  bool everyThingLoaded = false;

  var categoryFilterValue = '0';
  var filterValue = AppDefaults.filters[3];

  int skip = 0;
  int take = 6;

  @override
  void initState() {
    super.initState();
    getCategories();
    createTutorial();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });
  }

  Future<void> loadInitialData() async {
    products = await getNextPageData(page);
    // print('load initial data $products');
  }

  Future getNextPageData(int page) async {
    // await Future.delayed(const Duration(seconds: 2));
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      products += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
  }

  Future<void> getCategories() async {
    try {
      categories = [];
      var res = await Remote.get('categories', {});
      // print('res $res');
      if (res.statusCode == 200) {
        var dataJson = jsonDecode(res.body);
        for (var i = 0; i < dataJson['data'].length; i++) {
          categories.add(dataJson['data'][i]);
        }

        categories.insert(0, {'pk': 0, 'name': 'All'});

        setState(() async {
          loadInitialData();
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future fetch() async {
    try {
      var res = await Remote.get('products', {
        'type': 'product,all',
        'orderBy': filterValue,
        'categoryFilter': categoryFilterValue,
        'skip': skip.toString(),
        'take': take.toString(),
      });
      // print('res $res');
      if (res.statusCode == 200) {
        // return products;
        // setState(() {
        var dataJson = jsonDecode(res.body);

        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }
        return data;
        // });
      } else if (res.statusCode == 401) {
        if (!mounted) return [];
        AppDefaults.logout(context);
      }
      // if (res.statusCode == 200) return res.body;
      return [];
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }

    throw Exception();
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
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
      //   print("skip");
      // },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    'Product Post',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppDefaults.fontSize + 5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: SelectDropdownObj(
                        width: 100,
                        height: 55,
                        options: categories,
                        defaultValue: categoryFilterValue,
                        onChanged: (option) {
                          categoryFilterValue = option as String;
                          setState(() {
                            skip = 0;
                            loadInitialData();
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: SelectDropdown(
                        width: 120,
                        height: 55,
                        options: AppDefaults.filters,
                        defaultValue: filterValue,
                        onChanged: (option) {
                          filterValue = option as String;
                          setState(() {
                            skip = 0;
                            loadInitialData();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InfiniteScrollGrid(
              shrinkWrap: true,
              childAspectRatio: (1 / 1.3),
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              onLoadingStart: (page) async {
                // print(page);
                // _next();
              },
              everythingLoaded: everyThingLoaded,
              crossAxisCount: 2,
              children: products
                  .map(
                    (e) => GridItem(product: e),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final Map<String, dynamic> product;
  const GridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: ProductListWidgetTileSquare(
        product: product,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductPage(
                productPk: product['pk'],
              ),
            ),
          );
        },
      ),
    );
  }
}
