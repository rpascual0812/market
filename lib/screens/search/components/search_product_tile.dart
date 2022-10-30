import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';
import '../../chat/bubble.dart';

class SearchProductTile extends StatefulWidget {
  const SearchProductTile({
    Key? key,
    required this.filter,
    required this.product,
    this.onTap,
  }) : super(key: key);

  final String filter;
  final Map<String, dynamic> product;
  final void Function()? onTap;

  @override
  State<SearchProductTile> createState() => _SearchProductTileState();
}

class _SearchProductTileState extends State<SearchProductTile> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    var productImage = '${dotenv.get('API')}/assets/images/no-image.jpg';
    if (widget.product['product_documents'] != null) {
      productImage =
          AppDefaults.productImage(widget.product['product_documents']);
    }

    var sellerAddress = {};
    if (widget.product['seller_addresses'] != null) {
      for (var i = 0; i < widget.product['seller_addresses'].length; i++) {
        if (widget.product['seller_addresses'][i]['default']) {
          sellerAddress = widget.product['seller_addresses'][i];
        }
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
                                                    width: 150,
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
                                          Visibility(
                                            visible: widget.filter != 'Shops',
                                            child: Positioned(
                                              top: 15,
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
                                                      '${widget.product['country']['currency_symbol']}${double.parse(widget.product['price_from']).toStringAsFixed(2)}',
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
                                          ),
                                          Visibility(
                                            visible: widget.filter == 'Shops',
                                            child: Positioned(
                                              top: 15,
                                              right: 0,
                                              child: Container(
                                                width: 30.0,
                                                height: 30.0,
                                                padding: EdgeInsets.zero,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                  height: 20,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return const Bubble();
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      side: const BorderSide(
                                                        width: 1,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                    ),
                                                    child: const Icon(
                                                      chat,
                                                      color: AppColors.primary,
                                                      size:
                                                          AppDefaults.fontSize +
                                                              10,
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
