import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final storage = const FlutterSecureStorage();
  String? token = '';

  List orders = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  bool includeFutureCrops = false;

  @override
  void initState() {
    super.initState();
    readStorage();
    fetch();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
    });
  }

  Future<void> fetch() async {
    final token = await storage.read(key: 'jwt');
    var account = AppDefaults.jwtDecode(token);
    orders = [];
    try {
      var type = ['product'];
      if (includeFutureCrops) {
        type.add('future_crops');
      }

      final params = {
        'type': type.join(','),
        'user_pk': account['sub'].toString(),
        'status': 'Ordered'
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
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            orders.add(dataJson['data'][i]);
          }
        });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          // const SizedBox(height: 10),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Visibility(
              visible: orders.isNotEmpty ? true : false,
              child: ListView.builder(
                itemCount: orders.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // print(orders[index]);
                  return MyOrderTile(
                    token: token!,
                    order: orders[index],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            productPk: orders[index]['pk'],
                          ),
                        ),
                      );
                    },
                    refresh: () {
                      fetch();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
