import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../components/select_dropdown.dart';
import '../../../../constants/index.dart';
import 'my_producer_add_product.dart';
import 'my_products_tile.dart';

class MyProductsTab extends StatefulWidget {
  const MyProductsTab({
    Key? key,
    required this.type,
    required this.userPk,
  }) : super(key: key);

  final String type;
  final String userPk;

  @override
  State<MyProductsTab> createState() => _MyProductsTabState();
}

class _MyProductsTabState extends State<MyProductsTab> {
  bool includeFutureCrops = false;

  var filterValue = 'Sort by Date';
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
      products = [];
      // var res = await Remote.get(
      //     'products', {'orderBy': filterValue, 'owned': 'true'});
      var res = await Remote.get('sellers/${widget.userPk}/products',
          {'orderBy': filterValue, 'type': widget.type});
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
                        fetch();
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
                        style: TextStyle(fontSize: AppDefaults.fontSize),
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
                : ListView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return MyProductTile(product: products[index]);
                    }
                    // children: List.generate(
                    //     products.isNotEmpty ? dataJson['data'].length : 0,
                    //     (index) {
                    //   return MyProductTile(product: products[index]);
                    // }),
                    ),
          ],
        );
      });
}
