import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/components/section_divider_title.dart';

import '../../constants/index.dart';
// import 'info_row.dart';

class LookingForWidget extends StatefulWidget {
  const LookingForWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LookingForWidget> createState() => _LookingForWidgetState();
}

class _LookingForWidgetState extends State<LookingForWidget> {
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
      var res = await Remote.get('products');
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
                title: 'Looking For',
                onTap: () {},
              ),
              Container(
                margin: const EdgeInsets.all(0),
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Product',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Quantity',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Date',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                  rows: List.generate(
                      dataJson['data'] != null ? dataJson['data'].length : 0,
                      (index) {
                    DateTime date = DateTime.parse(
                        products[index]['date_created'].toString());
                    return DataRow(cells: [
                      DataCell(Text(products[index]['user']['first_name'],
                          style: const TextStyle(fontSize: 10))),
                      DataCell(Text(products[index]['name'],
                          style: const TextStyle(fontSize: 10))),
                      DataCell(Text(products[index]['quantity'],
                          style: const TextStyle(fontSize: 10))),
                      DataCell(Text(DateFormat.yMMMd().format(date),
                          style: const TextStyle(fontSize: 10))),
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
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
