import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';

class FutureCropsWidgetTile extends StatefulWidget {
  const FutureCropsWidgetTile({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> product;
  final void Function()? onTap;

  // String formattedDate = DateFormat('yyyy-MM-dd').format(date);

  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  State<FutureCropsWidgetTile> createState() => _FutureCropsWidgetTileState();
}

class _FutureCropsWidgetTileState extends State<FutureCropsWidgetTile> {
  @override
  Widget build(BuildContext context) {
    // var userImage =
    //     '${dotenv.get('API')}/${widget.product['user_document']['document']['path']}';
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    for (var i = 0; i < widget.product['user_document'].length; i++) {
      if (widget.product['user_document'][i]['document']['path'] != null &&
          widget.product['user_document'][i]['type'] == 'profile_photo') {
        userImage =
            '${dotenv.get('API')}/${widget.product['user_document'][i]['document']['path']}';
      }
    }

    DateTime date = DateTime.parse(widget.product['date_created'].toString());

    var userAddress = {};
    if (widget.product['user_addresses'] != null) {
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
    if (widget.product['seller_addresses'] != null) {
      var defaultFound = false;
      for (var i = 0; i < widget.product['seller_addresses'].length; i++) {
        if (widget.product['seller_addresses'][i]['default']) {
          defaultFound = true;
          sellerAddress = widget.product['seller_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = widget.product['seller_addresses'][0];
      }
    }

    // print('111 ${widget.product['date_created']}');
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.41,
      height: 125,
      // decoration: const BoxDecoration(color: Colors.red),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Material(
          color: Colors.white,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppDefaults.borderRadius,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              // padding: const EdgeInsets.all(AppDefaults.padding),
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 160,
                          height: 105,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius:
                            //     BorderRadius.circular(AppDefaults.radius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 5,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: SizedBox(
                                        height: 30,
                                        child: AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: NetworkImageWithLoader(
                                              userImage, true),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.product['user']
                                                ['first_name'],
                                            style: const TextStyle(
                                              fontSize:
                                                  AppDefaults.fontSize - 3,
                                              color: AppColors.defaultBlack,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                FutureCropsWidgetTile.pin,
                                                size: AppDefaults.fontSize - 5,
                                                // color: Colors.grey,
                                              ),
                                              Text(
                                                userAddress['city'] != null
                                                    ? '${userAddress['city']['name']}, ${userAddress['province']['name']}'
                                                    : '',
                                                style: const TextStyle(
                                                  fontSize:
                                                      AppDefaults.fontSize - 5,
                                                  color: AppColors.defaultBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Text(
                                        widget.product['name'],
                                        style: const TextStyle(
                                          fontSize: AppDefaults.fontSize,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                        'Quantity: ${widget.product['quantity'].toString()}',
                                        style: const TextStyle(
                                          fontSize: AppDefaults.fontSize - 2,
                                          color: AppColors.defaultBlack,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                        'Estimated date: ${DateFormat.MMM().format(date)} ${DateFormat.y().format(date)}',
                                        style: const TextStyle(
                                          fontSize: AppDefaults.fontSize - 4,
                                          color: AppColors.defaultBlack,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )

                        // SizedBox(
                        //   height: 180,
                        //   child: AspectRatio(
                        //     aspectRatio: 1 / 1,
                        //     child: Hero(
                        //       tag: imageLink,
                        //       child: NetworkImageWithLoader(
                        //         imageLink,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       name,
                        //       style: Theme.of(context).textTheme.bodyText2,
                        //       maxLines: 2,
                        //     ),
                        //     const SizedBox(height: 8),
                        //     Text(
                        //       // '\$${product.toInt()}',
                        //       product,
                        //       style: Theme.of(context).textTheme.bodyText1,
                        //       maxLines: 1,
                        //     )
                        //   ],
                        // )
                      ],
                    ),

                    /// This will show only when hasFavourite parameter is true
                    // if (widget.hasFavourite)
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
                    //         widget.isFavourite
                    //             ? IconlyBold.heart
                    //             : IconlyLight.heart,
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
      ),
    );
  }
}
