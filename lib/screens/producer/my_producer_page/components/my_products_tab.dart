import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/models/product.dart';
import 'package:market/screens/producer/my_producer_page/components/my_producer_add_product.dart';

import '../../../../constants/index.dart';
import 'my_products_tile.dart';

class MyProductsTab extends StatefulWidget {
  const MyProductsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProductsTab> createState() => _MyProductsTabState();
}

class _MyProductsTabState extends State<MyProductsTab> {
  bool includeFutureCrops = false;

  var filterValue = 'Sort by Category';
  var filters = ['Sort by Category', 'Sort by Name', 'Sort by Date'];

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SelectDropdown(options: filters, defaultValue: filterValue),
              Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                width: 150,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyProducerAddProduct(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
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
                    user: products[index].user,
                    userDocument: products[index].userDocument,
                    productDocument: products[index].productDocument,
                    measurement: products[index].measurement,
                    quantity: products[index].quantity,
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
