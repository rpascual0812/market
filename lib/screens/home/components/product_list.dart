import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/components/select_dropdown_obj.dart';
import 'package:market/screens/product/product_page.dart';

import '../../../constants/index.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.page});

  final int page;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int skip = 0;
  int take = 6;
  List categories = [];
  List products = [];
  int intialIndex = 0;
  bool isLoading = false;

  var categoryFilterValue = '0';
  var filterValue = AppDefaults.filters[3];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  /// Here is the important part: When data is set from the parent,
  /// move this widget
  @override
  void didUpdateWidget(covariant ProductList oldWidget) {
    // If you want to react only to changes you could check
    if (oldWidget.page != widget.page) {
      print(oldWidget.page.toString());
      print(widget.page.toString());
      print('didupdate');
      next();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void next() async {
    setState(() {
      Timer(const Duration(seconds: 2), () async {
        isLoading = false;

        print('next');
        skip += take;
        print('$skip $take');
        var data = await fetch();
        print(data.length);
        print(data);
        for (var i = 0; i < data.length; i++) {
          products.add(data[i]);
        }

        print('products count: ${products.length}');
      });
    });
  }

  Future<void> getCategories() async {
    try {
      categories = [];
      var res = await Remote.get('categories', {});
      // print('res $res');
      if (res.statusCode == 200) {
        var dataJson = jsonDecode(res.body);
        for (var i = 0; i < dataJson['data'].length; i++) {
          categories.add(dataJson['data'][i]);
        }

        categories.insert(0, {'pk': 0, 'name': 'All'});
        print(categories);
        setState(() async {
          // products = await fetch();
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

  Future fetch() async {
    try {
      isLoading = true;
      var res = await Remote.get('products', {
        'orderBy': filterValue,
        'categoryFilter': categoryFilterValue,
        'skip': skip.toString(),
        'take': take.toString(),
      });
      // print('res $res');
      if (res.statusCode == 200) {
        // return products;
        // setState(() {
        var dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }
        return data;
        // });
      } else if (res.statusCode == 401) {
        if (!mounted) return [];
        AppDefaults.logout(context);
      }
      // if (res.statusCode == 200) return res.body;
      return [];
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }

    throw Exception();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text(
              'Product Post',
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppDefaults.fontSize + 5,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: SelectDropdownObj(
                  width: 80,
                  height: 55,
                  options: categories,
                  defaultValue: categoryFilterValue,
                  onChanged: (option) {
                    categoryFilterValue = option as String;
                    setState(() {
                      fetch();
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: SelectDropdown(
                  width: 100,
                  height: 55,
                  options: AppDefaults.filters,
                  defaultValue: filterValue,
                  onChanged: (option) {
                    filterValue = option as String;
                    setState(() {
                      fetch();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      GridView.builder(
        padding: const EdgeInsets.all(0),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.68,
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductListWidgetTileSquare(
            product: products[index],
            onTap: () {
              // DateTime date =
              //     DateTime.parse(products[index].dateCreated.toString());
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
      isLoading
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('Fetching products...')),
            )
          : const SizedBox(height: AppDefaults.margin / 2),
    ]);
  }
}
