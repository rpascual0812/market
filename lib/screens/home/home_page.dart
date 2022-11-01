import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:market/components/cards/big/big_card_image.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/components/select_dropdown_obj.dart';
import 'package:market/components/sliders/home_slider.dart';
// import 'package:market/demo_data.dart';
import 'package:market/screens/future_crops/future_crops_widget.dart';
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
  List products = [];
  List categories = [];
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      categories = [];
      var res = await Remote.get('categories', {});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          var dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            categories.add(dataJson['data'][i]);
          }

          categories.insert(0, {'pk': 0, 'name': 'All'});
          print(categories);
          getProducts();
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

  Future<void> getProducts() async {
    try {
      products = [];
      var res = await Remote.get('products',
          {'orderBy': filterValue, 'categoryFilter': categoryFilterValue});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          var dataJson = jsonDecode(res.body);
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

  var categoryFilterValue = '0';
  var filterValue = AppDefaults.filters[3];

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
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                  child: SectionDividerTitle(
                    title: 'Product Post',
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
                            getProducts();
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
                            getProducts();
                          });
                        },
                      ),
                    ),
                  ],
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
                          productPk: products[index]['pk'],
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
