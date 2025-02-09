import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:market/screens/producer/my_producer_page/components/my_producer_edit_product.dart';

import '../../../../constants/index.dart';
import '../../../../components/network_image.dart';

import 'package:http/http.dart' as http;

class MyProductTile extends StatefulWidget {
  const MyProductTile({
    super.key,
    required this.type,
    required this.product,
    required this.onEdit,
    required this.refresh,
  });

  final String type;
  final Map<String, dynamic> product;
  final void Function() onEdit;
  final void Function() refresh;

  @override
  State<MyProductTile> createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
  final storage = const FlutterSecureStorage();
  String? token = '';

  @override
  void initState() {
    super.initState();
    readStorage();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
    });
  }

  delete(Map<String, dynamic> product) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/products/${product['pk']}');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
      var res = await http.delete(url, headers: headers);
      if (res.statusCode == 200) {
        widget.refresh();
      }
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var productImage = '${dotenv.get('API')}/assets/images/no-image.jpg';
    if (widget.product['product_documents'] != null) {
      productImage =
          AppDefaults.productImage(widget.product['product_documents']);
    }

    DateTime date = widget.type == 'future_crop'
        ? DateTime.parse(widget.product['date_available'].toString())
        : DateTime.parse(widget.product['date_created'].toString());

    return GestureDetector(
      // no onTap event for now
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Material(
          // color: Colors.white,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
            onTap: widget.onEdit,
            borderRadius: AppDefaults.borderRadius,
            child: Container(
              // margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.all(AppDefaults.padding),
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDefaults.margin,
                              vertical: AppDefaults.margin,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 65,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: NetworkImageWithLoader(
                                                  productImage, false),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: 150,
                                                height: 25,
                                                child: Text(
                                                  widget.product['name'],
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppDefaults.fontSize +
                                                            5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Wrap(
                                                spacing: 70, // set spacing here
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${widget.product['country']['currency_symbol']}${double.parse(widget.product['price_from']).toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontFamily: '',
                                                          fontSize: AppDefaults
                                                              .fontSize,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${widget.product['quantity']} ${widget.product['measurement']['symbol']}',
                                                        style: const TextStyle(
                                                          fontSize: AppDefaults
                                                              .fontSize,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Stocks: ${widget.product['quantity']}',
                                                        style: const TextStyle(
                                                          fontSize: AppDefaults
                                                              .fontSize,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Category: ${widget.product['category']['name']}',
                                                        style: const TextStyle(
                                                          fontSize: AppDefaults
                                                              .fontSize,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 5),
                                SizedBox(
                                  height: 25,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.type == 'future_crop'
                                              ? 'Available on: ${DateFormat.yMMMd().format(date)}'
                                              : 'Product created: ${DateFormat.yMMMd().format(date)}',
                                          style: const TextStyle(
                                            fontSize: AppDefaults.fontSize - 2,
                                            color: AppColors.defaultBlack,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AppColors.primary,
                                              ),
                                              width: 25.0,
                                              height: 25.0,
                                              padding: EdgeInsets.zero,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MyProducerEditProduct(
                                                          product:
                                                              widget.product,
                                                          onSave: () {
                                                            widget.refresh();
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: AppColors.primary,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AppColors.primary,
                                              ),
                                              width: 25.0,
                                              height: 25.0,
                                              padding: EdgeInsets.zero,
                                              child: OutlinedButton(
                                                onPressed: () async {
                                                  ArtDialogResponse response =
                                                      await ArtSweetAlert.show(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                        type: ArtSweetAlertType
                                                            .danger,
                                                        denyButtonText:
                                                            "Cancel",
                                                        denyButtonColor:
                                                            Colors.grey,
                                                        title:
                                                            "Are you sure you want to delete this product?",
                                                        confirmButtonText:
                                                            "Delete",
                                                        confirmButtonColor:
                                                            AppColors.danger),
                                                  );

                                                  if (response
                                                      .isTapConfirmButton) {
                                                    if (!mounted) return;
                                                    delete(widget.product);
                                                  }

                                                  if (response
                                                      .isTapDenyButton) {
                                                    return;
                                                  }
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: AppColors.primary,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
