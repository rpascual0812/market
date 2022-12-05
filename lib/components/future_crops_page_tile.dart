// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/screens/chat/bubble.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';
import '../screens/producer/producer_page/producer_page.dart';

class FutureCropsPageTile extends StatefulWidget {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const FutureCropsPageTile({
    Key? key,
    required this.token,
    required this.account,
    required this.product,
    this.onTap,
  }) : super(key: key);

  final String token;
  final Map<String, dynamic> account;
  final Map<String, dynamic> product;
  final void Function()? onTap;

  @override
  State<FutureCropsPageTile> createState() => _FutureCropsPageTileState();
}

class _FutureCropsPageTileState extends State<FutureCropsPageTile> {
  @override
  Widget build(BuildContext context) {
    var userImage = AppDefaults.userImage(widget.product['user_document']);
    DateTime date = DateTime.parse(widget.product['date_available'].toString());
    var productImage =
        AppDefaults.productImage(widget.product['product_documents']);

    // var userAddress = {};
    var userAddress = AppDefaults.userAddress(widget.product['user_addresses']);
    var sellerAddress =
        AppDefaults.sellerAddress(widget.product['user_addresses']);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 370,
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Center(
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
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
                                          height: 45,
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: NetworkImageWithLoader(
                                                userImage, true),
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          left: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: 150,
                                                  height: 15,
                                                  child: Text(
                                                    '${widget.product['user']['first_name']} ${widget.product['user']['last_name']}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: AppDefaults
                                                                .fontSize +
                                                            2),
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
                                                  height: 20,
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        FutureCropsPageTile.pin,
                                                        size: AppDefaults
                                                                .fontSize -
                                                            2,
                                                        color: Colors.grey,
                                                      ),
                                                      Text(
                                                        sellerAddress['city'] !=
                                                                null
                                                            ? '${sellerAddress['city']['name']}, ${sellerAddress['province']['name']}'
                                                            : '',
                                                        style: const TextStyle(
                                                          fontSize: AppDefaults
                                                              .fontSize,
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
                                          child: Row(
                                            children: [
                                              Visibility(
                                                visible: widget.account[
                                                                'user'] !=
                                                            null &&
                                                        widget.product[
                                                                'user_pk'] ==
                                                            widget.account[
                                                                'user']['pk']
                                                    ? false
                                                    : true,
                                                child: Container(
                                                  width: 35.0,
                                                  height: 35.0,
                                                  padding: EdgeInsets.zero,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Bubble(
                                                            token: widget.token,
                                                            userPk: widget
                                                                .account['user']
                                                                    ['pk']
                                                                .toString(),
                                                          ),
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
                                                      FutureCropsPageTile.chat,
                                                      color: AppColors.primary,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // const VerticalDivider(),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return ProducerPage(
                                                            userPk:
                                                                widget.product[
                                                                    'user_pk']);
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
                                                child: const Text(
                                                  'View Shop',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                              // TextButton(
                                              //   onPressed: () {},
                                              //   child: const Text('View Shop'),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDefaults.margin / 2),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.product['name'],
                                  style: const TextStyle(
                                    fontSize: AppDefaults.fontSize + 10,
                                    color: AppColors.defaultBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Quantity: ${widget.product['quantity']} ${widget.product['measurement']['symbol']}',
                                  style: const TextStyle(
                                    fontSize: AppDefaults.fontSize,
                                    color: AppColors.defaultBlack,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Estimated date: ${DateFormat.MMMM().format(date)} ${DateFormat.y().format(date)}',
                                  style: const TextStyle(
                                    fontSize: AppDefaults.fontSize,
                                    color: AppColors.defaultBlack,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Estimated Price: ${widget.product['country']['currency_symbol']}${widget.product['price_from']}',
                                  style: const TextStyle(
                                    fontFamily: '',
                                    fontSize: AppDefaults.fontSize,
                                    color: AppColors.defaultBlack,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 2),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: 200,
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: NetworkImageWithLoader(
                                      productImage, true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  /// This will show only when hasFavourite parameter is true
                  // if (hasFavourite)
                  //   Positioned(
                  //     top: 8,
                  //     right: 8,
                  //     child: Container(
                  //       padding: const EdgeInsets.all(8.0),
                  //       decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.white,
                  //       ),
                  //       child: Icon(
                  //         isFavourite ? IconlyBold.heart : IconlyLight.heart,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
