import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';

import 'package:market/models/order.dart';
import 'package:market/screens/producer/producer_page/producer_page.dart';
import 'package:market/screens/search/components/search_producer_tile.dart';
import 'package:market/screens/search/components/search_product_tile.dart';

import '../product/product_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();

  final storage = const FlutterSecureStorage();
  String? token = '';

  var filterValue = 'All';
  TextEditingController searchController = TextEditingController();

  late List<Order> orders = [];
  bool isLoading = false;

  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });

    loadInitialData();
  }

  Future fetch() async {
    try {
      var res =
          await Remote.get(filterValue == 'Shops' ? 'sellers' : 'products', {
        'keyword': searchController.text,
        'type': 'product',
        'filter': filterValue,
        'skip': skip.toString(),
        'take': take.toString(),
      });
      // print('res $res');
      if (res.statusCode == 200) {
        Map<Object, dynamic> dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (data.length <= take) {
          everyThingLoaded = true;
        }

        return data;
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

  Future<void> loadInitialData() async {
    products = await getNextPageData(page);
    // print('load initial data $products');
    setState(() {});
  }

  Future getNextPageData(int page) async {
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      products += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
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
                        onChanged: (value) => loadInitialData(),
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
                    onPressed: () {
                      setState(() {
                        searchController.text = '';
                        loadInitialData();
                      });
                    },
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
                        loadInitialData();
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
                        loadInitialData();
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
                        loadInitialData();
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
                        loadInitialData();
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
              child: InfiniteScrollList(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                onLoadingStart: (page) async {},
                everythingLoaded: everyThingLoaded,
                children: products
                    .map(
                      (product) => ListItem(
                        product: product,
                        filterValue: filterValue,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                productPk: product['pk'],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 30),
            Visibility(
              visible: products.isNotEmpty ? false : true,
              child: Center(
                child: Text(
                  'Your search \'${searchController.text}\' returns 0 results',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final String filterValue;
  final void Function()? onTap;

  const ListItem({
    Key? key,
    required this.product,
    required this.filterValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return filterValue == 'Shops'
        ? SearchProducerTile(
            user: product['user'],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProducerPage(
                    userPk: product['user']['pk'],
                  ),
                ),
              );
            },
          )
        : SearchProductTile(
            product: product,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    productPk: product['pk'],
                  ),
                ),
              );
            },
          );
  }
}
