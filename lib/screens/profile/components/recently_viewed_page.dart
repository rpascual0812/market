import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/components/appbar.dart';

import 'package:http/http.dart' as http;
import 'package:market/screens/product/product_page.dart';
import 'package:market/screens/profile/components/recently_viewed_page_tile.dart';

class RecentlyViewedPage extends StatefulWidget {
  const RecentlyViewedPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  State<RecentlyViewedPage> createState() => _RecentlyViewedPageState();
}

class _RecentlyViewedPageState extends State<RecentlyViewedPage> {
  final ScrollController _scrollController = ScrollController();

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
      final url = Uri.parse('${dotenv.get('API')}/products/seen');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
      };
      var res = await http.get(url, headers: headers);
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
      }
      return;
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();

    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
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
      appBar: const Appbar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Text(
                            'Recently viewed Products',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
              ),
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
                        token: widget.token,
                        product: product['product'],
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
              // child: ListView.builder(
              //   itemCount: products.length,
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.only(top: 16),
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return LookingForListTile(
              //       token: '',
              //       account: const {},
              //       product: products[index],
              //       onTap: () {
              //         // Navigator.of(context).push(
              //         //   MaterialPageRoute(
              //         //     builder: (context) => ProductPage(
              //         //       productPk: products[index]['pk'],
              //         //     ),
              //         //   ),
              //         // );
              //       },
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String token;
  final Map<String, dynamic> product;
  final void Function()? onTap;

  const ListItem({
    Key? key,
    required this.token,
    required this.product,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecentlyViewedPageTile(token: token, product: product, onTap: onTap);
  }
}
