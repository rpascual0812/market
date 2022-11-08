import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../../../constants/index.dart';
import 'package:http/http.dart' as http;

class LookingForList extends StatefulWidget {
  const LookingForList({Key? key, required this.type, required this.userPk})
      : super(key: key);

  final String type;
  final int userPk;

  @override
  State<LookingForList> createState() => _LookingForListState();
}

class _LookingForListState extends State<LookingForList> {
  bool includeFutureCrops = false;

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
      final params = {'type': widget.type};
      final url =
          Uri.parse('${dotenv.get('API')}/sellers/${widget.userPk}/products')
              .replace(queryParameters: params);

      var res = await http.get(
        url,
        // headers: headers,
      );

      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(dataJson['data'][i]);
            // print('products $products');
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
    return Column(
      children: [
        // const SizedBox(height: 10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                child: FittedBox(
                  child: DataTable(
                    showCheckboxColumn: false,
                    horizontalMargin: 0,
                    dataRowHeight: 25,
                    // columnSpacing: 0,
                    columns: const [
                      DataColumn(
                          label: Text('Product',
                              style: TextStyle(
                                  fontSize: AppDefaults.fontSize,
                                  fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Price Range',
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
                            if (selected != null && selected) {}
                          },
                          cells: [
                            DataCell(Text(products[index]['name'],
                                style: const TextStyle(
                                    fontSize: AppDefaults.fontSize - 2))),
                            DataCell(Text(
                                '${products[index]['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(products[index]['price_from']))} - ${products[index]['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(products[index]['price_to']))}',
                                style: const TextStyle(
                                    fontFamily: '',
                                    fontSize: AppDefaults.fontSize - 2))),
                            DataCell(Text(products[index]['quantity'],
                                style: const TextStyle(
                                    fontSize: AppDefaults.fontSize - 2))),
                            DataCell(Text(DateFormat.yMMMd().format(date),
                                style: const TextStyle(
                                    fontSize: AppDefaults.fontSize - 2))),
                          ]);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
