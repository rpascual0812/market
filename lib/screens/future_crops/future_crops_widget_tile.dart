import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';

class FutureCropsWidgetTile extends StatelessWidget {
  const FutureCropsWidgetTile({
    Key? key,
    required this.name,
    required this.product,
    required this.quantity,
    required this.description,
    required this.location,
    required this.imageLink,
    this.onTap,
    this.hasFavourite = false,
    this.isFavourite = false,
    this.onFavouriteClicked,
  }) : super(key: key);

  final String name;
  final String product;
  final String quantity;
  final String description;
  final String location;
  final String imageLink;
  final void Function()? onTap;
  final bool hasFavourite;
  final bool isFavourite;
  final void Function()? onFavouriteClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.50,
            // padding: const EdgeInsets.all(AppDefaults.padding),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
            child: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Hero(
                                        tag: imageLink,
                                        child: NetworkImageWithLoader(
                                          imageLink,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: AppColors.defaultBlack,
                                        ),
                                      ),
                                      Text(
                                        location,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: AppColors.defaultBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDefaults.margin / 2),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              Text(
                                'Quantity: $quantity',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.defaultBlack,
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              Text(
                                description,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.defaultBlack,
                                ),
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
                  if (hasFavourite)
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
                          isFavourite ? IconlyBold.heart : IconlyLight.heart,
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
    );
  }
}
