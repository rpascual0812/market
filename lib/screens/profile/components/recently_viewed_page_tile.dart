import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class RecentlyViewedPageTile extends StatefulWidget {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const RecentlyViewedPageTile({
    super.key,
    required this.token,
    required this.product,
    this.onTap,
  });

  final String token;
  final Map<String, dynamic> product;
  final void Function()? onTap;

  @override
  State<RecentlyViewedPageTile> createState() => _RecentlyViewedPageTileState();
}

class _RecentlyViewedPageTileState extends State<RecentlyViewedPageTile> {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    // print('product ${widget.product['user_addresses']}');

    DateTime date = DateTime.parse(widget.product['date_created'].toString());
    var productImage = '${dotenv.get('S3')}/images/no-image.jpg';
    if (widget.product['product_documents'] != null) {
      productImage =
          AppDefaults.productImage(widget.product['product_documents']);
    }

    return GestureDetector(
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
                                        top: 0,
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
                                                  widget.product['name'] ?? '',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppDefaults.fontSize +
                                                            5,
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
                                                  // '${widget.product['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.product['price_from']))} x${NumberFormat.decimalPattern().format(double.parse(widget.product['quantity']))}${widget.product['measurement']['symbol']}',
                                                  '${widget.product['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.product['price_from']))}',
                                                  style: const TextStyle(
                                                    fontFamily: '',
                                                    fontSize:
                                                        AppDefaults.fontSize,
                                                    color: AppColors.primary,
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
                                                  '1${widget.product['measurement']['symbol']}',
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
                                                  widget.product['status'] !=
                                                          null
                                                      ? widget.product['status']
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
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: 150,
                                        height: 20,
                                        child: Text(
                                          'Stocks: ${NumberFormat.decimalPattern().format(double.parse(widget.product['quantity']))}',
                                          style: const TextStyle(
                                            fontFamily: '',
                                            fontSize: AppDefaults.fontSize,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: 150,
                                        height: 20,
                                        child: Text(
                                          'Category: ${widget.product['category']['name']}',
                                          style: const TextStyle(
                                            fontFamily: '',
                                            fontSize: AppDefaults.fontSize,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                      'Post created: ${DateFormat.yMMMd().format(date)}',
                                      style: const TextStyle(
                                        fontSize: AppDefaults.fontSize,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.product['status_pk'] == 2 ||
                                            widget.product['status_pk'] == 6
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
                                              onPressed: () async {
                                                ArtDialogResponse response =
                                                    await ArtSweetAlert.show(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType
                                                          .question,
                                                      denyButtonText: "Cancel",
                                                      denyButtonColor:
                                                          Colors.grey,
                                                      title:
                                                          "Are you sure you want to update the status of this order?",
                                                      confirmButtonText:
                                                          "Update",
                                                      confirmButtonColor:
                                                          AppColors.primary),
                                                );

                                                if (response
                                                    .isTapConfirmButton) {
                                                  if (!mounted) return;
                                                }

                                                if (response.isTapDenyButton) {
                                                  return;
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
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
