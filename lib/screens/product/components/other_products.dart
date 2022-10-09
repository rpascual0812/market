import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/models/product.dart';

import '../../../constants/index.dart';
// import '../../product/product_page.dart';

class OtherProducts extends StatefulWidget {
  const OtherProducts({
    Key? key,
    required this.title,
    required this.theme,
  }) : super(key: key);

  final String title;
  final String theme;

  @override
  State<OtherProducts> createState() => _OtherProductsState();
}

class _OtherProductsState extends State<OtherProducts> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      height: 360,
      color: widget.theme == 'primary' ? AppColors.primary : Colors.white,
      // decoration: BoxDecoration(color: AppColors.primary),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.theme == 'white'
                          ? AppColors.primary
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 0),
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ProductListWidgetTileSquare(
                  pk: products[index].pk,
                  uuid: products[index].uuid,
                  name: products[index].name,
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  child: Text(
                    'View more',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
