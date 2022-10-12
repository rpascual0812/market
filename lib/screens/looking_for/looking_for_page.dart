import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:market/models/product.dart';
import 'package:market/screens/looking_for/looking_for_page_tile.dart';

import '../../constants/index.dart';

class LookingForPage extends StatefulWidget {
  const LookingForPage({Key? key}) : super(key: key);

  @override
  State<LookingForPage> createState() => _LookingForPageState();
}

class _LookingForPageState extends State<LookingForPage> {
  bool isLoading = false;
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

  // List<Products> products = [
  //   Products(
  //     pk: 1,
  //     uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
  //     title: 'Looking for Almonds',
  //     productImage: '',
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
  //     uuid: 'a21a82a0-7225-4c3c-b5f3-52ad16f68ca5',
  //     title: 'Looking for Banana Supplier',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Pinagbuhatan, Pasig City',
  //     type: 'looking',
  //     createdBy: 2,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 3,
  //     uuid: '40221260-267a-11ed-a261-0242ac120002',
  //     title: 'Looking for Almonds Supplier',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Sagad, Pasig City',
  //     type: 'looking',
  //     createdBy: 3,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 4,
  //     uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
  //     title: 'Looking for Almonds',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Palatiw, Pasig City',
  //     type: 'looking',
  //     createdBy: 1,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 5,
  //     uuid: 'a21a82a0-7225-4c3c-b5f3-52ad16f68ca5',
  //     title: 'Looking for Banana Supplier',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Pinagbuhatan, Pasig City',
  //     type: 'looking',
  //     createdBy: 2,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 6,
  //     uuid: '40221260-267a-11ed-a261-0242ac120002',
  //     title: 'Looking for Almonds Supplier',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Sagad, Pasig City',
  //     type: 'looking',
  //     createdBy: 3,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 7,
  //     uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
  //     title: 'Looking for Almonds',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Palatiw, Pasig City',
  //     type: 'looking',
  //     createdBy: 1,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 8,
  //     uuid: 'a21a82a0-7225-4c3c-b5f3-52ad16f68ca5',
  //     title: 'Looking for Banana Supplier',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Pinagbuhatan, Pasig City',
  //     type: 'looking',
  //     createdBy: 2,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  //   Products(
  //     pk: 9,
  //     uuid: '40221260-267a-11ed-a261-0242ac120002',
  //     title: 'Looking for Almonds Supplier',
  //     productImage: '',
  //     quantity: 103,
  //     unit: 'kg',
  //     description: 'Lorem ipsum dolor sit amet',
  //     location: 'Sagad, Pasig City',
  //     type: 'looking',
  //     createdBy: 3,
  //     userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
  //     userName: 'Juan Dela Cruz',
  //     dateCreated: DateTime(2022, 08, 12, 13, 25),
  //   ),
  // ];

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return LookingForPageTile(
                  pk: products[index].pk,
                  uuid: products[index].uuid,
                  name: products[index].name,
                  description: products[index].description,
                  productDocument: products[index].productDocument,
                  quantity: products[index].quantity,
                  measurement: products[index].measurement,
                  location: 'Sagad, Pasig City',
                  type: products[index].type,
                  user: products[index].user,
                  userDocument: products[index].userDocument,
                  dateCreated: products[index].dateCreated,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
