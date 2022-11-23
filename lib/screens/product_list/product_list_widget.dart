import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:market/constants/app_colors.dart';
// import 'package:market/components/product_list_widget_tile_square.dart';

import '../../components/product_list_widget_tile_square.dart';
import '../../constants/index.dart';
// import 'package:market/constants/app_defaults.dart';

// import '../../product/product_page.dart';

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
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
      var res = await Remote.get('products', {});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(dataJson['data'][i]);
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
      log('exception $exception');
    } catch (error) {
      log('error $error');
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
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
                product: products[index],
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
