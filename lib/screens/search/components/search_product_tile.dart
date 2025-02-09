import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class SearchProductTile extends StatefulWidget {
  const SearchProductTile({
    super.key,
    required this.product,
    this.onTap,
  });

  final Map<String, dynamic> product;
  final void Function()? onTap;

  @override
  State<SearchProductTile> createState() => _SearchProductTileState();
}

class _SearchProductTileState extends State<SearchProductTile> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);
  // static const IconData chat =
  //     IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    var productImage = '${dotenv.get('API')}/assets/images/no-image.jpg';
    if (widget.product['product_documents'] != null) {
      productImage =
          AppDefaults.productImage(widget.product['product_documents']);
    }

    var userAddress = {};
    if (widget.product['user_addresses'] != null &&
        widget.product['user_addresses'].length > 0) {
      var defaultFound = false;
      for (var i = 0; i < widget.product['user_addresses'].length; i++) {
        if (widget.product['user_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = widget.product['user_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = widget.product['user_addresses'][0];
      }
    }

    var sellerAddress = {};
    if (widget.product['user']['seller'] != null &&
        widget.product['user']['seller']['seller_address'] != null) {
      for (var i = 0;
          i < widget.product['user']['seller']['seller_address'].length;
          i++) {
        if (widget.product['user']['seller']['seller_address'][i]['default']) {
          sellerAddress = widget.product['user']['seller']['seller_address'][i];
        }
      }
    }

    var location = '';
    if (sellerAddress.isNotEmpty) {
      var city = '';
      if (sellerAddress['city'] != null) {
        city = sellerAddress['city']['name'];
      }
      var province = '';
      if (sellerAddress['province'] != null) {
        province = sellerAddress['province']['name'];
      }
      location = '$city, $province';
    } else {
      var city = '';
      if (userAddress['city'] != null) {
        city = userAddress['city']['name'];
      }
      var province = '';
      if (userAddress['province'] != null) {
        province = userAddress['province']['name'];
      }
      location = '$city, $province';
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
                                            left: 75,
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
                                                    width: 200,
                                                    height: 18,
                                                    child: Text(
                                                      widget.product['name'] ??
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
                                                    width: 200,
                                                    height: 16,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          pin,
                                                          size: 12,
                                                          color: Colors.grey,
                                                        ),
                                                        Text(
                                                          location,
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
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              width: 100.0,
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
                                                    widget.product['country'] !=
                                                            null
                                                        ? '${widget.product['country']['currency_symbol']}${double.parse(widget.product['price_from']).toStringAsFixed(2)}'
                                                        : '',
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
