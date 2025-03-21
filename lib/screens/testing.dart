import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/components/select_dropdown_obj.dart';
import 'package:market/components/sliders/home_slider.dart';
import 'package:market/screens/future_crops/future_crops_widget.dart';
import 'package:market/screens/home/components/article_list.dart';
import 'package:market/screens/looking_for/looking_for_widget.dart';
import 'package:market/screens/product/product_page.dart';
import 'package:market/size_config.dart';

import '../constants/index.dart';

class GridExample extends StatefulWidget {
  const GridExample({super.key});

  @override
  State<GridExample> createState() => _GridExampleState();
}

class _GridExampleState extends State<GridExample> {
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

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });

    // loadInitialData();
  }

  Future getNextPageData(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    // if (page == 3) return [];
    // final items = List<String>.generate(6, (i) => "Item $i Page $page");
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      products += newData;
      if (newData.isEmpty) {
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
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  Future fetch() async {
    try {
      var res = await Remote.get('products', {
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
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }

    throw Exception();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: const Appbar(module: 'home'),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: HomeSlider(),
            ),
            const SizedBox(height: AppDefaults.margin / 2),
            const ArticleList(),
            const SizedBox(height: AppDefaults.margin),
            const FutureCropsWidget(),
            const SizedBox(height: AppDefaults.margin),
            const LookingForWidget(),
            const SizedBox(height: AppDefaults.margin),
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
                        width: 80,
                        height: 55,
                        options: categories,
                        defaultValue: categoryFilterValue,
                        onChanged: (option) {
                          categoryFilterValue = option as String;
                          setState(() {
                            fetch();
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: SelectDropdown(
                        width: 100,
                        height: 55,
                        options: AppDefaults.filters,
                        defaultValue: filterValue,
                        onChanged: (option) {
                          filterValue = option as String;
                          setState(() {
                            fetch();
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

  Future<void> loadInitialData() async {
    products = await getNextPageData(page);
    // print('load initial data $products');
    setState(() {});
  }
}

class GridItem extends StatelessWidget {
  final Map<String, dynamic> product;
  const GridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
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
