import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/models/product.dart';
import 'package:market/screens/orders/components/my_product_tile.dart';

import '../../../constants/index.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  List<Products> products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  bool includeFutureCrops = false;

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
              category: dataJson['data'][i]['category'],
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
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.98,
          height: 50,
          child: Row(
            children: [
              Switch(
                value: includeFutureCrops,
                onChanged: (value) {
                  setState(() {
                    includeFutureCrops = value;
                  });
                },
              ),
              InkWell(
                child: const Text(
                  'Include Future Crops',
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  setState(() {
                    includeFutureCrops = !includeFutureCrops;
                  });
                },
              )
            ],
          ),
        ),
        // const SizedBox(height: 10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                // padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return MyProductTile(
                    pk: products[index].pk,
                    uuid: products[index].uuid,
                    name: products[index].name,
                    productDocument: products[index].productDocument,
                    user: products[index].user,
                    userDocument: products[index].userDocument,
                    quantity: products[index].quantity,
                    measurement: products[index].measurement,
                    description: products[index].description,
                    location: '',
                    type: products[index].type,
                    dateCreated: products[index].dateCreated,
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
