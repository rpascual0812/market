import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';

import 'package:market/models/order.dart';
import 'package:market/screens/search/components/search_product_tile.dart';

import '../product/product_page.dart';
import 'components/search_producer_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var filterValue = 'All';
  TextEditingController searchController = TextEditingController();

  late List<Order> orders = [];
  bool isLoading = false;

  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    try {
      var res = await Remote.get('products',
          {'keyword': searchController.text, 'filter': filterValue});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          products = [];
          dataJson = jsonDecode(res.body);
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
      log('exception $exception');
    } catch (error) {
      log('error $error');
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
            const Appbar(),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) => fetch(),
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
                        fetch();
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
                        fetch();
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
                        fetch();
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
                        fetch();
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
            Visibility(
              visible: products.isNotEmpty ? true : false,
              child: ListView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return filterValue == 'Shops'
                        ? SearchProducerTile(
                            product: products[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    productPk: products[index]['pk'],
                                  ),
                                ),
                              );
                            },
                          )
                        : SearchProductTile(
                            product: products[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    productPk: products[index]['pk'],
                                  ),
                                ),
                              );
                            },
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
