import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/components/select_dropdown_obj.dart';
import 'package:market/screens/product/product_page.dart';

import '../../../constants/index.dart';

class ProductList extends StatefulWidget {
  const ProductList({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int skip = 0;
  int take = 4;
  List categories = [];
  List products = [];
  int intialIndex = 0;

  var categoryFilterValue = '0';
  var filterValue = AppDefaults.filters[3];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCategories() async {
    try {
      categories = [];
      var res = await Remote.get('categories', {});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() async {
          var dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            categories.add(dataJson['data'][i]);
          }

          categories.insert(0, {'pk': 0, 'name': 'All'});
          // print(categories);
          products = await fetch();
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
      products = [];
      var res = await Remote.get('products', {
        'orderBy': filterValue,
        'categoryFilter': categoryFilterValue,
        'skip': skip.toString(),
        'take': take.toString(),
      });
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          var dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(dataJson['data'][i]);
          }
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return products;
        AppDefaults.logout(context);
      }
      // if (res.statusCode == 200) return res.body;
      return products;
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
    ]);
  }
}
