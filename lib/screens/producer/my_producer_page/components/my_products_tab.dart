import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/screens/product/product_page.dart';

import '../../../../components/select_dropdown.dart';
import '../../../../constants/index.dart';
import 'my_producer_add_product.dart';
import 'my_products_tile.dart';

class MyProductsTab extends StatefulWidget {
  const MyProductsTab({
    super.key,
    required this.type,
    required this.userPk,
  });

  final String type;
  final String userPk;

  @override
  State<MyProductsTab> createState() => _MyProductsTabState();
}

class _MyProductsTabState extends State<MyProductsTab> {
  final ScrollController _scrollController = ScrollController();
  bool includeFutureCrops = false;

  bool isLoading = false;
  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  var filterValue = 'Sort by Date';
  var filters = ['Sort by Category', 'Sort by Name', 'Sort by Date'];

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

  @override
  void initState() {
    super.initState();
    // fetch();

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
      products = [];
      // var res = await Remote.get(
      //     'products', {'orderBy': filterValue, 'owned': 'true'});
      var res = await Remote.get('sellers/${widget.userPk}/products',
          {'orderBy': filterValue, 'type': widget.type});
      if (res.statusCode == 200) {
        dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (products.length >= skip) {
          everyThingLoaded = true;
        }

        return data;
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
      return;
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);
  }

  Future<void> loadInitialData() async {
    products = await getNextPageData(page);
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
    // print(widget.type);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: buildOrders(),
        ),
      ],
    );
  }

  Widget buildOrders() => ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SelectDropdown(
                    onChanged: (option) {
                      filterValue = option as String;
                      setState(() {
                        loadInitialData();
                      });
                    },
                    width: 160,
                    height: 55,
                    options: filters,
                    defaultValue: filterValue,
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    width: 150,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MyProducerAddProduct(type: widget.type),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                      ),
                      child: const Text(
                        'Add Product',
                        style: TextStyle(fontSize: AppDefaults.fontSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            products.isEmpty
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppDefaults.margin * 2),
                      Text(
                        'No products found',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                    type: widget.type,
                                    product: product,
                                    onEdit: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                            productPk: products[index]['pk'],
                                          ),
                                        ),
                                      );
                                    },
                                    refresh: () {
                                      loadInitialData();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
            // ListView.builder(
            //     itemCount: products.length,
            //     shrinkWrap: true,
            //     physics: const ClampingScrollPhysics(),
            //     itemBuilder: (BuildContext context, int index) {
            //       return MyProductTile(
            //         type: widget.type,
            //         product: products[index],
            //         onEdit: () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) => ProductPage(
            //                 productPk: products[index]['pk'],
            //               ),
            //             ),
            //           );
            //         },
            //         refresh: () {
            //           // print('deleted');
            //           fetch();
            //         },
            //       );
            //     }
            //     // children: List.generate(
            //     //     products.isNotEmpty ? dataJson['data'].length : 0,
            //     //     (index) {
            //     //   return MyProductTile(product: products[index]);
            //     // }),
            //     ),
          ],
        );
      });
}

class ListItem extends StatelessWidget {
  final String type;
  final Map<String, dynamic> product;
  final void Function() onEdit;
  final void Function() refresh;

  const ListItem({
    super.key,
    required this.type,
    required this.product,
    required this.onEdit,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return MyProductTile(
      type: type,
      product: product,
      onEdit: onEdit,
      refresh: refresh,
    );
  }
}
