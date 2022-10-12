import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';
import 'package:market/models/product.dart';

import 'package:market/models/order.dart';
import 'package:market/screens/search/components/search_product_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var filterValue = 'All';
  var filters = ['Show All', 'Show only unread', 'Mark all as read'];

  late List<Order> orders = [];
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Appbar(),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: AppDefaults.fontSize,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 25,
                          ),
                          // filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        filterValue = 'All';
                      });
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero, // and this
                    ),
                    child: Text(
                      'All',
                      style: TextStyle(
                        fontSize: 12,
                        color: filterValue == 'All'
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        filterValue = 'Location';
                      });
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero, // and this
                    ),
                    child: Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: filterValue == 'Location'
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        filterValue = 'Products';
                      });
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero, // and this
                    ),
                    child: Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 12,
                        color: filterValue == 'Products'
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 30,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        filterValue = 'Shops';
                      });
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero, // and this
                    ),
                    child: Text(
                      'Shops',
                      style: TextStyle(
                        fontSize: 12,
                        color: filterValue == 'Shops'
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SearchProductTile(
                  pk: products[index].pk,
                  uuid: products[index].uuid,
                  name: products[index].name,
                  description: products[index].description,
                  productDocument: products[index].productDocument,
                  quantity: products[index].quantity,
                  measurement: products[index].measurement,
                  location: '',
                  type: products[index].type,
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
