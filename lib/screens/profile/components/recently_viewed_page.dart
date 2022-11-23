import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/looking_for/looking_for_list_tile.dart';

import '../../../constants/index.dart';

class RecentlyViewedPage extends StatefulWidget {
  const RecentlyViewedPage({Key? key}) : super(key: key);

  @override
  State<RecentlyViewedPage> createState() => _RecentlyViewedPageState();
}

class _RecentlyViewedPageState extends State<RecentlyViewedPage> {
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
          // print(products);
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
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
              child: ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return LookingForListTile(
                    product: products[index],
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ProductPage(
                      //       productPk: products[index]['pk'],
                      //     ),
                      //   ),
                      // );
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
