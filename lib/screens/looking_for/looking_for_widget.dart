import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:market/components/section_divider_title.dart';
import 'package:market/screens/looking_for/looking_for_page.dart';

import '../../constants/index.dart';
import '../approot/app_root.dart';
// import 'info_row.dart';

class LookingForWidget extends StatefulWidget {
  const LookingForWidget({
    super.key,
  });

  @override
  State<LookingForWidget> createState() => _LookingForWidgetState();
}

class _LookingForWidgetState extends State<LookingForWidget> {
  final storage = const FlutterSecureStorage();
  String? token = '';

  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    readStorage();
    getProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
    });
  }

  Future<void> getProducts() async {
    try {
      var res = await Remote.get(
          'products', {'type': 'looking_for', 'skip': '0', 'take': '10'});
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
      log('exception $exception');
    } catch (error) {
      log('error $error');
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
              topLeft: Radius.circular(AppDefaults.radius),
              topRight: Radius.circular(AppDefaults.radius),
              bottomLeft: Radius.circular(AppDefaults.radius),
              bottomRight: Radius.circular(AppDefaults.radius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
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
                title: 'Looking Forbbbbbbbbbb',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AppRoot(
                        jwt: token ?? '',
                        menuIndex: 1,
                        subIndex: 1,
                      ),
                    ),
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.all(0),
                child: FittedBox(
                  child: DataTable(
                    showCheckboxColumn: false,
                    horizontalMargin: 0,
                    dataRowMinHeight: 25,
                    // columnSpacing: 0,
                    columns: const [
                      DataColumn(
                          label: Text('Name',
                              style: TextStyle(
                                  fontSize: AppDefaults.fontSize,
                                  fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Product',
                              style: TextStyle(
                                  fontSize: AppDefaults.fontSize,
                                  fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Quantity',
                              style: TextStyle(
                                  fontSize: AppDefaults.fontSize,
                                  fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Date Posted',
                              style: TextStyle(
                                  fontSize: AppDefaults.fontSize,
                                  fontWeight: FontWeight.bold))),
                    ],
                    rows: List.generate(
                        dataJson['data'] != null ? dataJson['data'].length : 0,
                        (index) {
                      DateTime date = DateTime.parse(
                          products[index]['date_created'].toString());
                      return DataRow(
                          onSelectChanged: (bool? selected) {
                            if (selected != null && selected) {
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
                            }
                          },
                          cells: [
                            DataCell(Text(
                                '${products[index]['user']['first_name']} ${products[index]['user']['last_name']}',
                                style: const TextStyle(
                                    fontSize: AppDefaults.fontSize - 2))),
                            DataCell(Text(products[index]['name'],
                                style: const TextStyle(
                                    fontSize: AppDefaults.fontSize - 2))),
                            DataCell(Text(
                                '${products[index]['quantity']} ${products[index]['measurement']['symbol']}',
                                style: const TextStyle(
                                    fontSize: AppDefaults.fontSize - 2))),
                            DataCell(Text(DateFormat.yMMMd().format(date),
                                style: const TextStyle(
                                    fontSize: AppDefaults.fontSize - 2))),
                          ]);
                    }),
                    // rows: const [
                    //   DataRow(cells: [
                    //     DataCell(Text('1', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Stephen', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Actor', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Actor', style: TextStyle(fontSize: 10))),
                    //   ]),
                    //   DataRow(cells: [
                    //     DataCell(Text('5', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('John', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Student', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Student', style: TextStyle(fontSize: 10))),
                    //   ]),
                    //   DataRow(cells: [
                    //     DataCell(Text('10', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Harry', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Leader', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Leader', style: TextStyle(fontSize: 10))),
                    //   ]),
                    //   DataRow(cells: [
                    //     DataCell(Text('15', style: TextStyle(fontSize: 10))),
                    //     DataCell(Text('Peter', style: TextStyle(fontSize: 10))),
                    //     DataCell(
                    //         Text('Scientist', style: TextStyle(fontSize: 10))),
                    //     DataCell(
                    //         Text('Scientist', style: TextStyle(fontSize: 10))),
                    //   ]),
                    // ],
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
