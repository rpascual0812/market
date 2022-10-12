import 'dart:convert';

import 'package:flutter/material.dart';
import '../../components/section_divider_title.dart';
import '../../constants/index.dart';
import 'future_crops_widget_tile.dart';
// import '../../product/product_page.dart';
import 'package:market/screens/product/product_page.dart';

class FutureCropsWidget extends StatefulWidget {
  const FutureCropsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FutureCropsWidget> createState() => _FutureCropsWidgetState();
}

class _FutureCropsWidgetState extends State<FutureCropsWidget> {
  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getProducts() async {
    try {
      var res = await Remote.get('products', {});
      // print('res $res');
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
    return Material(
      color: Colors.white70,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        borderRadius: AppDefaults.borderRadius,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            children: [
              SectionDividerTitle(
                title: 'Future Crops',
                onTap: () {},
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      dataJson['data'] != null ? dataJson['data'].length : 0,
                      (index) {
                    return FutureCropsWidgetTile(
                      product: products[index],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              product: products[index],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: AppDefaults.height / 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
