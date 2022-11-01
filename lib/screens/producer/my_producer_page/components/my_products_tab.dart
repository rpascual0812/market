import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/screens/producer/my_producer_page/components/my_producer_add_product.dart';
import 'package:market/screens/producer/my_producer_page/components/my_products_tile.dart';

import '../../../../constants/index.dart';

class MyProductsTab extends StatefulWidget {
  const MyProductsTab({Key? key}) : super(key: key);

  @override
  State<MyProductsTab> createState() => _MyProductsTabState();
}

class _MyProductsTabState extends State<MyProductsTab> {
  bool includeFutureCrops = false;

  var filterValue = 'Sort by Category';
  var filters = ['Sort by Category', 'Sort by Name', 'Sort by Date'];

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
      var res = await Remote.get('products', {});
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(dataJson['data'][i]);
          }
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
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
        Expanded(
          child: Center(
            child: buildOrders(),
          ),
        ),
      ],
    );
  }

  Widget buildOrders() => ListView(
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
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
                          builder: (context) => const MyProducerAddProduct(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.zero),
                    ),
                    child: const Text(
                      'Add Product',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          products.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'No products found',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    )
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: List.generate(
                      products.isNotEmpty ? dataJson['data'].length : 0,
                      (index) {
                    return MyProductTile(product: products[index]);
                  }),
                ),
        ],
      );
}
