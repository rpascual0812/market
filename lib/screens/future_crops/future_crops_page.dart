import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:intl/intl.dart';
import 'package:market/components/future_crops_page_tile.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';

import '../../constants/remote.dart';
import '../product/product_page.dart';

class FutureCropsPage extends StatefulWidget {
  const FutureCropsPage({
    super.key,
    required this.token,
    required this.account,
  });

  final String token;
  final Map<String, dynamic> account;

  @override
  State<FutureCropsPage> createState() => _FutureCropsPageState();
}

class _FutureCropsPageState extends State<FutureCropsPage> {
  final ScrollController _scrollController = ScrollController();

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
    {'name': 'January', 'selected': false, 'count': 0},
    {'name': 'February', 'selected': false, 'count': 0},
    {'name': 'March', 'selected': false, 'count': 0},
    {'name': 'April', 'selected': false, 'count': 0},
    {'name': 'May', 'selected': false, 'count': 0},
    {'name': 'June', 'selected': false, 'count': 0},
    {'name': 'July', 'selected': false, 'count': 0},
    {'name': 'August', 'selected': false, 'count': 0},
    {'name': 'September', 'selected': false, 'count': 0},
    {'name': 'October', 'selected': false, 'count': 0},
    {'name': 'November', 'selected': false, 'count': 0},
    {'name': 'December', 'selected': false, 'count': 0},
  ];

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

  @override
  void initState() {
    monthlyCount();

    isLoading = true;
    super.initState();

    for (var i = 0; i < months.length; i++) {
      if (months[i]['name'] == monthNow) {
        months[i]['selected'] = true;
      }
    }

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });

    loadInitialData();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();
    // yearController.dispose();
    super.dispose();
  }

  Future monthlyCount() async {
    try {
      var monthsArr = [];
      for (var month in months) {
        monthsArr.add(jsonEncode(<String, String>{
          'name': month['name'],
        }));
      }

      var res = await Remote.get('products', {
        'type': 'future_crop',
        'year': yearController.text,
        'months': monthsArr.toString(),
        'skip': skip.toString(),
        'take': take.toString()
      });

      if (res.statusCode == 200) {
        dataJson = jsonDecode(res.body);
        for (var i = 0; i < dataJson['data'].length; i++) {
          var month = dataJson['data'][i]['date_available_formatted'];
          months[month]['count']++;
        }
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

  Future fetch() async {
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
      // products = [];
      var res = await Remote.get('products', {
        'type': 'future_crop',
        'year': yearController.text,
        'months': monthsArr.toString(),
        'skip': skip.toString(),
        'take': take.toString()
      });
      // print('res $res');
      if (res.statusCode == 200) {
        dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        return data;
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

  Future<void> loadInitialData() async {
    products = await getNextPageData(page);
    // print('load initial data $products');
    setState(() {});
  }

  Future getNextPageData(int page) async {
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      products += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
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
        controller: _scrollController,
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
                                    color: Colors.grey.withValues(alpha: 0.3),
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

                                              loadInitialData();
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

                                              loadInitialData();
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
                                                  loadInitialData();
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: months[index]
                                                        ['selected']
                                                    ? AppColors.primary
                                                    : months[index]['count'] > 0
                                                        ? AppColors.secondary
                                                        : Colors.grey,
                                                minimumSize:
                                                    Size.zero, // Set this
                                                padding:
                                                    EdgeInsets.zero, // and this
                                              ),
                                              child: Text(
                                                '${months[index]['name']}',
                                                style: const TextStyle(
                                                    fontSize:
                                                        AppDefaults.fontSize,
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
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No products found',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                  ],
                )
              : InfiniteScrollList(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  onLoadingStart: (page) async {},
                  everythingLoaded: everyThingLoaded,
                  children: products
                      .map(
                        (product) => ListItem(
                          token: widget.token,
                          account: widget.account,
                          product: product,
                        ),
                      )
                      .toList(),
                )
          // ListView(
          //     shrinkWrap: true,
          //     physics: const ClampingScrollPhysics(),
          //     children: List.generate(
          //         products.isNotEmpty ? dataJson['data'].length : 0,
          //         (index) {
          //       return FutureCropsPageTile(
          //         token: widget.token,
          //         account: widget.account,
          //         product: products[index],
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) => ProductPage(
          //                 productPk: products[index]['pk'],
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     }),
          //   ),
        ],
      );
}

class ListItem extends StatelessWidget {
  final String token;
  final Map<String, dynamic> account;
  final Map<String, dynamic> product;
  const ListItem({
    super.key,
    required this.token,
    required this.account,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return FutureCropsPageTile(
      token: token,
      account: account,
      product: product,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(
              productPk: product['pk'],
            ),
          ),
        );
      },
    );
  }
}
