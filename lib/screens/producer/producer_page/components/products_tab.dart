import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../components/product_list_widget_tile_square.dart';
import '../../../../constants/index.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  bool includeFutureCrops = false;

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
      var res = await Remote.get('products');
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
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SizedBox(height: 10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
            ],
          ),
        ),
      ],
    );
  }
}
