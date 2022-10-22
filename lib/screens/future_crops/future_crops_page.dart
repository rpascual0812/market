import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/components/future_crops_page_tile.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';

import '../../constants/remote.dart';
import '../product/product_page.dart';

class FutureCropsPage extends StatefulWidget {
  const FutureCropsPage({Key? key}) : super(key: key);

  @override
  State<FutureCropsPage> createState() => _FutureCropsPageState();
}

class _FutureCropsPageState extends State<FutureCropsPage> {
  // late List<Order> orders = [];
  bool isLoading = false;

  List products = [];
  Map<Object, dynamic> dataJson = {};

  static const IconData leftArrow =
      IconData(0xe801, fontFamily: 'Custom', fontPackage: null);
  static const IconData rightArrow =
      IconData(0xe803, fontFamily: 'Custom', fontPackage: null);

  TextEditingController yearController =
      TextEditingController(text: DateFormat.y().format(DateTime.now()));

  var monthNow = DateFormat.MMMM().format(DateTime.now());

  final List months = [
    {'name': 'January', 'selected': false},
    {'name': 'February', 'selected': false},
    {'name': 'March', 'selected': false},
    {'name': 'April', 'selected': false},
    {'name': 'May', 'selected': false},
    {'name': 'June', 'selected': false},
    {'name': 'July', 'selected': false},
    {'name': 'August', 'selected': false},
    {'name': 'September', 'selected': false},
    {'name': 'October', 'selected': false},
    {'name': 'November', 'selected': false},
    {'name': 'December', 'selected': false},
  ];

  @override
  void initState() {
    isLoading = true;
    super.initState();

    for (var i = 0; i < months.length; i++) {
      if (months[i]['name'] == monthNow) {
        months[i]['selected'] = true;
      }
    }

    getProducts();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();
    // yearController.dispose();
    super.dispose();
  }

  Future<void> getProducts() async {
    try {
      // products = [];

      var monthsArr = [];

      for (var month in months) {
        if (month['selected']) {
          monthsArr.add(jsonEncode(<String, String>{
            'name': month['name'],
          }));
        }
      }

      var res = await Remote.get('products', {
        'type': 'future_crops',
        'year': yearController.text,
        'months': monthsArr.toString(),
      });
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
      isLoading = false;
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Widget getTabWidget(String title, double padding, bool isTabSelected) {
    return isTabSelected
        ? Text(title)
        : Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.primary,
            child: Center(
                child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: buildOrders(),
            // child: products.isEmpty
            //     ? const Text(
            //         'No data found',
            //         style: TextStyle(color: Colors.black, fontSize: 24),
            //       )
            //     : buildOrders(),
          ),
        ),
      ],
    );
  }

  Widget buildOrders() => ListView(
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Material(
              color: Colors.white,
              borderRadius: AppDefaults.borderRadius,
              child: InkWell(
                onTap: () {},
                borderRadius: AppDefaults.borderRadius,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 210,
                  // padding: const EdgeInsets.all(AppDefaults.padding),
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Center(
                    child: Stack(
                      children: [
                        Column(
                          // mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: IconButton(
                                          icon: const Icon(leftArrow),
                                          onPressed: () {
                                            setState(() {
                                              yearController.text = (int.parse(
                                                          yearController.text) -
                                                      1)
                                                  .toString();

                                              getProducts();
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white10,
                                          child: TextField(
                                            controller: yearController,
                                            autocorrect: true,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: IconButton(
                                          icon: const Icon(rightArrow),
                                          onPressed: () {
                                            setState(() {
                                              yearController.text = (int.parse(
                                                          yearController.text) +
                                                      1)
                                                  .toString();

                                              getProducts();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: AppDefaults.margin),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: List.generate(
                                      months.length,
                                      (index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.29,
                                            height: 30,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  months[index]['selected'] =
                                                      !months[index]
                                                          ['selected'];
                                                  getProducts();
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: months[index]
                                                        ['selected']
                                                    ? AppColors.primary
                                                    : Colors.grey,
                                                minimumSize:
                                                    Size.zero, // Set this
                                                padding:
                                                    EdgeInsets.zero, // and this
                                              ),
                                              child: Text(
                                                months[index]['name'],
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: AppDefaults.margin * 2,
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
                    return FutureCropsPageTile(
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
                  }),
                ),
        ],
      );
}
