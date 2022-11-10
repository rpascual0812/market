import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_switch/flutter_switch.dart';
// import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class CartPageTile extends StatefulWidget {
  const CartPageTile({
    Key? key,
    required this.order,
    this.onTap,
    required this.onToggle,
  }) : super(key: key);

  final Map<String, dynamic> order;
  final void Function()? onTap;
  final void Function() onToggle;

  @override
  State<CartPageTile> createState() => _CartPageTileState();
}

class _CartPageTileState extends State<CartPageTile> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    var productImage = '${dotenv.get('API')}/assets/images/no-image.jpg';
    if (widget.order['product']['product_documents'] != null) {
      productImage = AppDefaults.productImage(
          widget.order['product']['product_documents']);
    }

    var sellerAddress = {};
    if (widget.order['product']['seller_addresses'] != null) {
      var defaultFound = false;
      for (var i = 0;
          i < widget.order['product']['seller_addresses'].length;
          i++) {
        if (widget.order['product']['seller_addresses'][i]['default']) {
          defaultFound = true;
          sellerAddress = widget.order['product']['seller_addresses'][i];
        }
      }

      if (!defaultFound) {
        sellerAddress = widget.order['product']['seller_addresses'][0];
      }
    }

    return GestureDetector(
      onTap: widget.onTap,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FlutterSwitch(
                                      width: 40.0,
                                      height: 20.0,
                                      toggleSize: 15.0,
                                      value: widget.order['product']
                                                      ['selected'] !=
                                                  null &&
                                              widget.order['product']
                                                      ['selected'] ==
                                                  true
                                          ? true
                                          : false,
                                      onToggle: (val) {
                                        setState(() {
                                          widget.order['product']['selected'] =
                                              widget.order['product']
                                                          ['selected'] !=
                                                      null
                                                  ? !widget.order['product']
                                                      ['selected']
                                                  : true;

                                          widget.onToggle();
                                        });
                                      },
                                    ),
                                    const VerticalDivider(),
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
                                            top: 15,
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
                                                    height: 18,
                                                    child: Text(
                                                      widget.order['product']
                                                              ['name'] ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontSize: 16,
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
                                                          size: 12,
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
                                                            fontSize: 10,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 15,
                                            right: 0,
                                            child: Container(
                                              width: 70.0,
                                              height: 25.0,
                                              padding: EdgeInsets.zero,
                                              child: SizedBox(
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
                                                  child: Text(
                                                    '${widget.order['product']['country']['currency_symbol']}${double.parse(widget.order['product']['price_from']).toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontFamily: '',
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
