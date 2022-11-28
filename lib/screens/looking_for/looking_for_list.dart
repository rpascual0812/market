import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/screens/looking_for/looking_for_list_tile.dart';
import 'package:market/screens/looking_for/looking_for_page.dart';

import '../../constants/index.dart';

class LookingForList extends StatefulWidget {
  const LookingForList({
    Key? key,
    required this.token,
    required this.account,
  }) : super(key: key);

  final String token;
  final Map<String, dynamic> account;

  @override
  State<LookingForList> createState() => _LookingForListState();
}

class _LookingForListState extends State<LookingForList> {
  bool isLoading = false;
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
      var res = await Remote.get('products', {'type': 'looking_for'});
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
            Visibility(
              visible: products.isNotEmpty ? true : false,
              child: ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return LookingForListTile(
                    token: widget.token,
                    account: widget.account,
                    product: products[index],
                    onTap: () {
                      Navigator.of(context).push(
                        // MaterialPageRoute(
                        //   builder: (context) => ProductPage(
                        //     productPk: products[index]['pk'],
                        //   ),
                        // ),
                        MaterialPageRoute(
                          builder: (context) {
                            return LookingForPage(
                                productPk: products[index]['pk']);
                          },
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
