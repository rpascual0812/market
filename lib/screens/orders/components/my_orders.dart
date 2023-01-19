import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/screens/orders/components/my_order_tile.dart';

import '../../../constants/index.dart';

import 'package:http/http.dart' as http;

import '../../product/product_page.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> user;

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final ScrollController _scrollController = ScrollController();
  final storage = const FlutterSecureStorage();
  String? token = '';

  List orders = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  bool includeFutureCrops = false;

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

  @override
  void initState() {
    super.initState();
    readStorage();

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

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
    });
  }

  Future fetch() async {
    final token = await storage.read(key: 'jwt');
    var account = AppDefaults.jwtDecode(token);

    try {
      var type = ['product'];
      if (includeFutureCrops) {
        type.add('future_crops');
      }

      final params = {
        'type': type.join(','),
        'user_pk': account['sub'].toString(),
        'status': 'Ordered',
        'skip': skip.toString(),
        'take': take.toString(),
      };

      final url = Uri.parse('${dotenv.get('API')}/orders')
          .replace(queryParameters: params);
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

      var res = await http.get(
        url,
        headers: headers,
      );

      if (res.statusCode == 200) {
        dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (data.length <= take) {
          everyThingLoaded = true;
        }

        return data;
      }
      // else if (res.statusCode == 401) {
      //   if (!mounted) return;
      //   AppDefaults.logout(context);
      // }
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future<void> loadInitialData() async {
    orders = await getNextPageData(page);
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
      orders += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
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
                      loadInitialData();
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
            child: Visibility(
              visible: orders.isNotEmpty ? true : false,
              child: InfiniteScrollList(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                onLoadingStart: (page) async {},
                everythingLoaded: everyThingLoaded,
                children: orders
                    .map(
                      (order) => ListItem(
                        token: token!,
                        order: order,
                        refresh: () {
                          _next();
                        },
                      ),
                    )
                    .toList(),
              ),
              // child: ListView.builder(
              //   itemCount: orders.length,
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.only(top: 16),
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     // print(orders[index]);
              //     return MyOrderTile(
              //       token: token!,
              //       order: orders[index],
              //       onTap: () {
              //         Navigator.of(context).push(
              //           MaterialPageRoute(
              //             builder: (context) => ProductPage(
              //               productPk: orders[index]['pk'],
              //             ),
              //           ),
              //         );
              //       },
              //       refresh: () {
              //         fetch();
              //       },
              //     );
              //   },
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String token;
  final Map<String, dynamic> order;
  final void Function()? refresh;

  const ListItem({
    Key? key,
    required this.token,
    required this.order,
    this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyOrderTile(
      token: token,
      order: order,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(
              productPk: order['pk'],
            ),
          ),
        );
      },
      refresh: () {
        refresh!();
      },
    );
  }
}
