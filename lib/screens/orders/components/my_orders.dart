import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/models/product.dart';
import 'package:market/screens/orders/components/my_order_tile.dart';

import '../../../constants/index.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({
    Key? key,
  }) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
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

  // List<Products> products = [
  //   Products(
  //     pk: 1,
  //     uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
  //     title: 'Banana',
  //     productImage: 'https://i.imgur.com/R3Cpn1T.jpeg',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Palatiw, Pasig City',
  //     type: 'looking',
  //     createdBy: 1,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Raffier Lee',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 2,
  //     uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
  //     title: 'Tomato',
  //     productImage: 'https://i.imgur.com/fFrzEcg.jpeg',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Palatiw, Pasig City',
  //     type: 'looking',
  //     createdBy: 1,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Raffier Lee',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  // ];

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
                  return MyOrderTile(
                    pk: products[index].pk,
                    uuid: products[index].uuid,
                    user: products[index].user,
                    productDocument: products[index].productDocument,
                    userDocument: products[index].userDocument,
                    name: products[index].name,
                    quantity: products[index].quantity,
                    description: products[index].description,
                    location: 'Palatiw, Pasig City',
                    type: products[index].type,
                    date: products[index].dateCreated,
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
