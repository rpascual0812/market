import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:market/components/cards/big/big_card_image.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/components/sliders/home_slider.dart';
// import 'package:market/demo_data.dart';
import 'package:market/screens/future_crops/future_crops_widget.dart';
import 'package:market/screens/home/components/article_list.dart';
import 'package:market/screens/home/components/home_header.dart';
import 'package:market/screens/looking_for/looking_for_widget.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
import 'package:market/size_config.dart';

import '../../components/product_list_widget_tile_square.dart';
import '../../components/section_divider_title.dart';
import '../../constants/app_defaults.dart';
import '../../constants/remote.dart';
import '../product/product_page.dart';

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
  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      products = [];
      var res = await Remote.get('products', {'orderBy': filterValue});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(dataJson['data'][i]);
          }
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

  var filterValue = 'Lowest Price';

  var filters = [
    'Best Seller',
    'Newest',
    'Highest Price',
    'Lowest Price',
    'Average Rating',
    'Vegetables',
    'Fruits',
    'Seeds',
    'Herbs',
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SingleChildScrollView(
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
            const SizedBox(height: AppDefaults.margin / 2),
            // const SearchBar(),
            const SizedBox(height: AppDefaults.margin / 2),
            const ArticleList(),
            const SizedBox(height: AppDefaults.margin),
            const FutureCropsWidget(),
            const SizedBox(height: AppDefaults.margin / 2),
            const LookingForWidget(),
            const SizedBox(height: AppDefaults.margin),
            // const ProductListWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                  child: SectionDividerTitle(
                    title: 'Product Post',
                  ),
                ),
                SelectDropdown(
                  options: filters,
                  defaultValue: filterValue,
                  onChanged: (option) {
                    filterValue = option as String;
                    setState(() {
                      getProducts();
                    });
                  },
                ),
              ],
            ),
            GridView.builder(
              padding: const EdgeInsets.all(0),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.68,
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return ProductListWidgetTileSquare(
                  product: products[index],
                  onTap: () {
                    // DateTime date =
                    //     DateTime.parse(products[index].dateCreated.toString());
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          product: products[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppDefaults.margin / 2),
          ],
        ),
      ),
    );
  }
}
