import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/screens/orders/components/my_looking_for_tile.dart';

import '../../../constants/index.dart';

import 'package:http/http.dart' as http;

import '../../product/product_page.dart';

class MyLookingFor extends StatefulWidget {
  const MyLookingFor({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> user;

  @override
  State<MyLookingFor> createState() => _MyLookingForState();
}

class _MyLookingForState extends State<MyLookingFor> {
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
      var type = ['looking_for'];
      if (includeFutureCrops) {
        type.add('future_crops');
      }

      final params = {
        'type': type.join(','),
        'seller': account['sub'].toString(),
        'skip': skip.toString(),
        'take': take.toString(),
        // 'status': 'Ordered'
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
          Visibility(
            visible: false,
            child: Container(
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
                        fetch();
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
              //     return MyLookingForTile(
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
    return MyLookingForTile(
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
