import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class MyOrderTile extends StatefulWidget {
  const MyOrderTile({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> order;
  final void Function()? onTap;

  @override
  State<MyOrderTile> createState() => _MyOrderTileState();
}

class _MyOrderTileState extends State<MyOrderTile> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(widget.order['date_created'].toString());
    var productImage = '${dotenv.get('API')}/assets/images/no-image.jpg';
    if (widget.order['product_documents'] != null) {
      productImage =
          AppDefaults.productImage(widget.order['product_documents']);
    }

    var sellerAddress = {};
    if (widget.order['seller_addresses'] != null) {
      for (var i = 0; i < widget.order['seller_addresses'].length; i++) {
        if (widget.order['seller_addresses'][i]['default']) {
          sellerAddress = widget.order['seller_addresses'][i];
        }
      }
    }

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Material(
          // color: Colors.white,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
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
                                SizedBox(
                                  height: 25,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Stack(
                                          children: [
                                            const Positioned(
                                              left: 0,
                                              child: Icon(
                                                Icons.store,
                                                color: Colors.grey,
                                                size: AppDefaults.fontSize,
                                              ),
                                            ),
                                            Positioned(
                                              left: 15,
                                              child: Text(
                                                '${widget.order['seller']['first_name']} ${widget.order['seller']['last_name']}',
                                                style: const TextStyle(
                                                  fontSize:
                                                      AppDefaults.fontSize,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Text(
                                                widget.order['status'] != null
                                                    ? widget.order['status']
                                                        ['name']
                                                    : ''
                                                        '',
                                                style: const TextStyle(
                                                  fontSize:
                                                      AppDefaults.fontSize,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 75,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: NetworkImageWithLoader(
                                                  productImage, false),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            left: 85,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 150,
                                                    height: 25,
                                                    child: Text(
                                                      widget.order['product']
                                                              ['name'] ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontSize: AppDefaults
                                                                .fontSize +
                                                            8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 150,
                                                    height: 16,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          pin,
                                                          size: AppDefaults
                                                                  .fontSize -
                                                              2,
                                                          color: Colors.grey,
                                                        ),
                                                        Text(
                                                          sellerAddress[
                                                                      'city'] !=
                                                                  null
                                                              ? '${sellerAddress['address']}, ${sellerAddress['city']['name']} ${sellerAddress['province']['name']}'
                                                              : '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: AppDefaults
                                                                    .fontSize -
                                                                2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '${widget.order['product']['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.order['product']['price_from']))} x${NumberFormat.decimalPattern().format(double.parse(widget.order['product']['quantity']))}',
                                                  style: const TextStyle(
                                                    fontFamily: '',
                                                    fontSize: 12,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                                width: 120.0,
                                                height: 70.0,
                                                padding: EdgeInsets.zero,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    // Text(
                                                    //   'Delivered',
                                                    //   style: TextStyle(
                                                    //     fontSize: 12,
                                                    //     color:
                                                    //         AppColors.primary,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      'Order Total: ${widget.order['product']['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.order['product']['price_from']) * double.parse(widget.order['product']['quantity']))}',
                                                      style: const TextStyle(
                                                        fontFamily: '',
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 25,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Order created: ${DateFormat.yMMMd().format(date)}',
                                          style: const TextStyle(
                                            fontSize: AppDefaults.fontSize - 2,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Positioned(
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
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  minimumSize:
                                                      Size.zero, // Set this
                                                  padding: EdgeInsets
                                                      .zero, // and this
                                                ),
                                                child: const Text(
                                                  'Received',
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
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.danger,
                                                  minimumSize:
                                                      Size.zero, // Set this
                                                  padding: EdgeInsets
                                                      .zero, // and this
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
