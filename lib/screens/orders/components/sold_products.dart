import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/screens/orders/components/sold_product_tile.dart';

import '../../../main.dart';

import 'package:http/http.dart' as http;

import '../../product/product_page.dart';

class SoldProducts extends StatefulWidget {
  const SoldProducts({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> user;

  @override
  State<SoldProducts> createState() => _SoldProductsState();
}

class _SoldProductsState extends State<SoldProducts> {
  List orders = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  bool includeFutureCrops = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final token = await storage.read(key: 'jwt');
    orders = [];
    try {
      var type = ['looking_for'];
      if (includeFutureCrops) {
        type.add('future_crops');
      }

      final params = {'type': type.join(',')};
      final url = Uri.parse('${dotenv.get('API')}/orders/sold')
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
    return Column(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: orders.isNotEmpty ? true : false,
                child: ListView.builder(
                  itemCount: orders.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // print(orders[index]);
                    return SoldProductTile(
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
