import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

import 'package:http/http.dart' as http;

class SoldProductTile extends StatefulWidget {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const SoldProductTile({
    super.key,
    required this.token,
    required this.order,
    this.onTap,
    this.refresh,
  });

  final String token;
  final Map<String, dynamic> order;
  final void Function()? onTap;
  final void Function()? refresh;

  @override
  State<SoldProductTile> createState() => _SoldProductTileState();
}

class _SoldProductTileState extends State<SoldProductTile> {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  update(String status) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/orders/update');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
      };
      var body = {'order_pks': widget.order['pk'].toString(), 'status': status};
      var res = await http.post(url, headers: headers, body: body);
      if (res.statusCode == 200) {
        widget.refresh!();
      }
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('product ${widget.product['user_addresses']}');

    DateTime date = DateTime.parse(widget.order['date_created'].toString());
    DateTime dateAvailable =
        DateTime.parse(widget.order['product']['date_available'].toString());

    var productImage = '${dotenv.get('S3')}/images/no-image.png';
    if (widget.order['product']['product_documents'] != null) {
      productImage = AppDefaults.productImage(
          widget.order['product']['product_documents']);
    }

    return GestureDetector(
      // no onTap event for now
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Material(
          // color: Colors.white,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
            borderRadius: AppDefaults.borderRadius,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.all(AppDefaults.padding),
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Center(
                child: Stack(
                  children: [
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
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 65,
                                        child: AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: NetworkImageWithLoader(
                                              productImage, false),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        left: 75,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                width: 200,
                                                height: 25,
                                                child: Text(
                                                  widget.order['product']
                                                          ['name'] ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppDefaults.fontSize +
                                                            8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                width: 200,
                                                height: 20,
                                                child: Text(
                                                  '${widget.order['product']['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.order['product']['price_from']))} x${NumberFormat.decimalPattern().format(double.parse(widget.order['product']['quantity']))}',
                                                  style: const TextStyle(
                                                    fontFamily: '',
                                                    fontSize:
                                                        AppDefaults.fontSize,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                            width: 130.0,
                                            height: 100.0,
                                            padding: EdgeInsets.zero,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  widget.order['status'] != null
                                                      ? widget.order['status']
                                                          ['name']
                                                      : ''
                                                          '',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppDefaults.fontSize -
                                                            2,
                                                    color: AppColors.secondary,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Order Total: ${widget.order['product']['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.order['product']['price_from']) * double.parse(widget.order['product']['quantity']))}',
                                                  style: const TextStyle(
                                                    fontFamily: '',
                                                    fontSize:
                                                        AppDefaults.fontSize,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )),
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
                                      'Order created: ${DateFormat.yMMMd().format(date)}',
                                      style: const TextStyle(
                                        fontSize: AppDefaults.fontSize,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.order['status_pk'] == 2 ||
                                            widget.order['status_pk'] == 6
                                        ? true
                                        : false,
                                    child: Positioned(
                                      right: 0,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            height: 20,
                                            child: ElevatedButton(
                                              onPressed:
                                                  dateAvailable.compareTo(
                                                              DateTime.now()) >
                                                          0
                                                      ? null
                                                      : () async {
                                                          ArtDialogResponse
                                                              response =
                                                              await ArtSweetAlert
                                                                  .show(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            artDialogArgs: ArtDialogArgs(
                                                                type: ArtSweetAlertType
                                                                    .question,
                                                                denyButtonText:
                                                                    "Cancel",
                                                                denyButtonColor:
                                                                    Colors.grey,
                                                                title:
                                                                    "Are you sure you want to update the status of this order?",
                                                                confirmButtonText:
                                                                    "Update",
                                                                confirmButtonColor:
                                                                    AppColors
                                                                        .primary),
                                                          );

                                                          if (response
                                                              .isTapConfirmButton) {
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            update('Fulfilled');
                                                          }

                                                          if (response
                                                              .isTapDenyButton) {
                                                            return;
                                                          }
                                                        },
                                              style: TextButton.styleFrom(
                                                backgroundColor: dateAvailable
                                                            .compareTo(DateTime
                                                                .now()) >
                                                        0
                                                    ? Colors.grey
                                                    : AppColors.primary,
                                                minimumSize:
                                                    Size.zero, // Set this
                                                padding:
                                                    EdgeInsets.zero, // and this
                                              ),
                                              child: const Text(
                                                'Fulfilled',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            height: 20,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                ArtDialogResponse response =
                                                    await ArtSweetAlert.show(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType
                                                          .danger,
                                                      denyButtonText: "Close",
                                                      denyButtonColor:
                                                          Colors.grey,
                                                      title:
                                                          "Are you sure you want to cancel this order?",
                                                      confirmButtonText:
                                                          "Cancel",
                                                      confirmButtonColor:
                                                          AppColors.danger),
                                                );

                                                if (response
                                                    .isTapConfirmButton) {
                                                  if (!mounted) return;
                                                  update('Cancelled');
                                                }

                                                if (response.isTapDenyButton) {
                                                  return;
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.danger,
                                                minimumSize:
                                                    Size.zero, // Set this
                                                padding:
                                                    EdgeInsets.zero, // and this
                                              ),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
