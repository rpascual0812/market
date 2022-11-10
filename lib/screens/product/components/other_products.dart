import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/screens/producer/my_producer_page/my_producer_page.dart';

import '../../../constants/index.dart';
import '../product_page.dart';
// import '../../product/product_page.dart';

class OtherProducts extends StatefulWidget {
  const OtherProducts({
    Key? key,
    this.userPk = '',
    required this.title,
    required this.theme,
    required this.token,
    required this.accountPk,
  }) : super(key: key);

  final String userPk;
  final String title;
  final String theme;
  final String token;
  final String accountPk;

  @override
  State<OtherProducts> createState() => _OtherProductsState();
}

class _OtherProductsState extends State<OtherProducts> {
  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      Map<String, String> filters = {};
      if (widget.userPk != '') {
        filters = {'user_pk': widget.userPk};
      }

      var res = await Remote.get('products', filters);
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(dataJson['data'][i]);
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      height: 370,
      color: widget.theme == 'primary' ? AppColors.primary : Colors.white,
      // decoration: BoxDecoration(color: AppColors.primary),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.theme == 'white'
                          ? AppColors.primary
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDefaults.fontSize + 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 0),
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ProductListWidgetTileSquare(
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
              },
            ),
          ),
          Visibility(
            visible: widget.title == 'Similar Products' ? false : true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: SizedBox(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyProducerPage(
                              token: widget.token,
                              accountPk: widget.accountPk.toString(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'View more',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
