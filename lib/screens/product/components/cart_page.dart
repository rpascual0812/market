import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/screens/product/components/cart_page_tile.dart';

import '../../../components/appbar.dart';
import '../../../constants/index.dart';
import '../../product/product_page.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  List orders = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    // try {
    final token = widget.token;
    final url = Uri.parse('${dotenv.get('API')}/orders/cart');
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    var res = await http.get(
      url,
      headers: headers,
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      setState(() {
        dataJson = jsonDecode(res.body);
        print('dataJson $dataJson');
        for (var i = 0; i < dataJson['data'].length; i++) {
          dataJson['data'][i]['selected'] = false;
          orders.add(dataJson['data'][i]);
        }
      });
    }
    return;
    // } on Exception catch (exception) {
    //   print('exception $exception');
    // } catch (error) {
    //   print('error $error');
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
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
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5, top: 5),
                    width: 50,
                    child: InkWell(
                      onTap: (() => Navigator.of(context).pop()),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 80.0,
                    height: 30.0,
                    padding: EdgeInsets.zero,
                    child: OutlinedButton(
                      onPressed: () async {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          width: 1,
                          color: AppColors.primary,
                        ),
                        padding: const EdgeInsets.all(5),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: orders.isNotEmpty ? true : false,
              child: ListView.builder(
                itemCount: orders.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 5),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CartPageTile(
                    order: orders[index],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            productPk: orders[index]['product']['pk'],
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
    );
  }
}
