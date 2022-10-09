import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:market/components/cards/big/big_card_image.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/components/sliders/home_slider.dart';
import 'package:market/constants/app_colors.dart';
// import 'package:market/demo_data.dart';
import 'package:market/models/product.dart';
import 'package:market/screens/future_crops/future_crops_widget.dart';
import 'package:market/screens/home/components/article_list.dart';
import 'package:market/screens/home/components/home_header.dart';
import 'package:market/screens/looking_for/looking_for_widget.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
// import 'package:market/screens/product_list/product_list_widget.dart';
import 'package:market/size_config.dart';

import '../../components/product_list_widget_tile_square.dart';
import '../../constants/app_defaults.dart';
import '../../constants/remote.dart';

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
  List<Products> products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      var res = await Remote.get('products');
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(Products(
              pk: dataJson['data'][i]['pk'],
              uuid: dataJson['data'][i]['uuid'],
              type: dataJson['data'][i]['type'],
              name: dataJson['data'][i]['name'],
              description: dataJson['data'][i]['description'],
              quantity: dataJson['data'][i]['quantity'],
              priceFrom: dataJson['data'][i]['price_from'],
              priceTo: dataJson['data'][i]['price_to'],
              user: dataJson['data'][i]['user'],
              measurement: dataJson['data'][i]['measurement'],
              country: dataJson['data'][i]['country'],
              userDocument: dataJson['data'][i]['user_document'],
              productDocument: dataJson['data'][i]['product_document'],
              dateCreated: dataJson['data'][i]['date_created'],
            ));
            // print('products $products');
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
            const SizedBox(height: AppDefaults.margin / 2),
            // const ProductListWidget(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                  child: Text(
                    'Product Post',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SelectDropdown(options: filters, defaultValue: filterValue),
              ],
            ),
            GridView.builder(
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
                  pk: products[index].pk,
                  name: products[index].name,
                  uuid: products[index].uuid,
                  description: products[index].description,
                  priceFrom: products[index].priceFrom,
                  priceTo: products[index].priceTo,
                  productDocument: products[index].productDocument,
                  hasFavourite: true,
                  isFavourite: true,
                  ratings: 3.5,
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ProductPage(
                    //       pk: products[index].pk,
                    //       uuid: products[index].uuid,
                    //       title: products[index].title,
                    //       productImage: products[index].productImage,
                    //       quantity: products[index].quantity,
                    //       unit: products[index].unit,
                    //       description: products[index].description,
                    //       location: products[index].location,
                    //       type: products[index].type,
                    //       createdBy: products[index].createdBy,
                    //       userImage: products[index].userImage,
                    //       userName: products[index].userName,
                    //       dateCreated: products[index].dateCreated,
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            ),

            // ListView.builder(
            //   itemCount: products.length,
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.only(top: 16),
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     return ProductListWidgetTileSquare(
            //       pk: products[index].pk,
            //       title: 'Banana',
            //       price: 165,
            //       imageLink: 'https://i.imgur.com/R3Cpn1T.jpeg',
            //       hasFavourite: true,
            //       isFavourite: true,
            //       ratings: 3.5,
            //       onTap: () {},
            //     );
            //   },
            // ),
            const SizedBox(height: AppDefaults.margin / 2),
          ],
        ),
      ),
    );
  }
}
