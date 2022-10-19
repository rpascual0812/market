import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/components/future_crops_page_tile.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';

import 'package:market/models/order.dart';

import '../../constants/remote.dart';

class FutureCropsPage extends StatefulWidget {
  const FutureCropsPage({Key? key}) : super(key: key);

  @override
  State<FutureCropsPage> createState() => _FutureCropsPageState();
}

class _FutureCropsPageState extends State<FutureCropsPage> {
  late List<Order> orders = [];
  bool isLoading = false;

  List products = [];
  Map<Object, dynamic> dataJson = {};

  static const IconData leftArrow =
      IconData(0xe801, fontFamily: 'Custom', fontPackage: null);
  static const IconData rightArrow =
      IconData(0xe803, fontFamily: 'Custom', fontPackage: null);

  TextEditingController yearController =
      TextEditingController(text: DateFormat.y().format(DateTime.now()));

  final List months = [
    {'month': 'January', 'selected': false},
    {'month': 'February', 'selected': false},
    {'month': 'March', 'selected': false},
    {'month': 'April', 'selected': false},
    {'month': 'May', 'selected': false},
    {'month': 'June', 'selected': false},
    {'month': 'July', 'selected': false},
    {'month': 'August', 'selected': false},
    {'month': 'September', 'selected': false},
    {'month': 'October', 'selected': false},
    {'month': 'November', 'selected': false},
    {'month': 'December', 'selected': false},
  ];

  @override
  void initState() {
    isLoading = true;
    super.initState();
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
      products = [];
      var res = await Remote.get('products', {'type': 'future_crops'});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          print(dataJson);
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
            child: products.isEmpty
                ? const Text(
                    'No data found',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  )
                : buildOrders(),
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
                                                    ? AppColors.secondary
                                                    : AppColors.primary,
                                                minimumSize:
                                                    Size.zero, // Set this
                                                padding:
                                                    EdgeInsets.zero, // and this
                                              ),
                                              child: Text(
                                                months[index]['month'],
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
          ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: List.generate(
                dataJson['data'] != null ? dataJson['data'].length : 0,
                (index) {
              return FutureCropsPageTile(
                product: products[index],
                onTap: () {},
              );
            }),
            // children: [
            //   FutureCropsPageTile(
            //     product: products[index],
            //     onTap: () {},
            //   ),
            //   FutureCropsPageTile(
            //     pk: 2,
            //     name: 'Juan Dela Cruz',
            //     profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            //     product: 'Banana Supplier',
            //     quantity: '103 kg',
            //     date: 'April 2022',
            //     price: 'P 200 per kilo',
            //     location: 'Davao',
            //     productPhoto: 'https://i.imgur.com/R3Cpn1T.jpeg',
            //     onTap: () {},
            //   ),
            //   FutureCropsPageTile(
            //     pk: 3,
            //     name: 'Juan Dela Cruz',
            //     profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            //     product: 'Almonds',
            //     quantity: '103 kg',
            //     date: 'April 2022',
            //     price: 'P 200 per kilo',
            //     productPhoto: 'https://i.imgur.com/zdLsFZ0.jpeg',
            //     location: 'Davao',
            //     onTap: () {},
            //   ),
            //   FutureCropsPageTile(
            //     pk: 4,
            //     name: 'Juan Dela Cruz',
            //     profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            //     product: 'Banana Supplier',
            //     quantity: '103 kg',
            //     date: 'April 2022',
            //     price: 'P 200 per kilo',
            //     productPhoto: 'https://i.imgur.com/R3Cpn1T.jpeg',
            //     location: 'Davao',
            //     onTap: () {},
            //   ),
            //   FutureCropsPageTile(
            //     pk: 5,
            //     name: 'Juan Dela Cruz',
            //     profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            //     product: 'Almonds',
            //     quantity: '103 kg',
            //     date: 'April 2022',
            //     price: 'P 200 per kilo',
            //     productPhoto: 'https://i.imgur.com/zdLsFZ0.jpeg',
            //     location: 'Davao',
            //     onTap: () {},
            //   ),
            //   FutureCropsPageTile(
            //     pk: 6,
            //     name: 'Juan Dela Cruz',
            //     profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            //     product: 'Banana Supplier',
            //     quantity: '103 kg',
            //     date: 'April 2022',
            //     price: 'P 200 per kilo',
            //     productPhoto: 'https://i.imgur.com/R3Cpn1T.jpeg',
            //     location: 'Davao',
            //     onTap: () {},
            //   ),
            // ],
          ),
        ],
      );
}
