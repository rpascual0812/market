import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';

class FutureCropsWidgetTile extends StatefulWidget {
  const FutureCropsWidgetTile({
    Key? key,
    required this.pk,
    required this.uuid,
    required this.user,
    required this.userDocument,
    required this.productDocument,
    required this.measurement,
    required this.name,
    required this.description,
    required this.quantity,
    required this.location,
    required this.date,
    this.onTap,
    this.hasFavourite = false,
    this.isFavourite = false,
    this.onFavouriteClicked,
  }) : super(key: key);

  final int pk;
  final String uuid;
  final Map<String, dynamic> user;
  final List userDocument;
  final List productDocument;
  final Map<String, dynamic> measurement;
  final String name;
  final String description;
  final String quantity;
  final String location;
  final DateTime date;
  final void Function()? onTap;
  final bool hasFavourite;
  final bool isFavourite;
  final void Function()? onFavouriteClicked;

  // String formattedDate = DateFormat('yyyy-MM-dd').format(date);

  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  State<FutureCropsWidgetTile> createState() => _FutureCropsWidgetTileState();
}

class _FutureCropsWidgetTileState extends State<FutureCropsWidgetTile> {
  @override
  Widget build(BuildContext context) {
    var userImage =
        '${dotenv.get('API')}/${widget.userDocument[0]['document']['path']}';

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.31,
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
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
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
                                            widget.name,
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
                                                widget.location,
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
                                        widget.name,
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
                                        'Quantity: ${widget.quantity.toString()}',
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
                                        'Estimated date: ${DateFormat.MMM().format(widget.date)} ${DateFormat.y().format(widget.date)}',
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
                    if (widget.hasFavourite)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            widget.isFavourite
                                ? IconlyBold.heart
                                : IconlyLight.heart,
                            color: Colors.red,
                          ),
                        ),
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
