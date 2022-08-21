import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';

class ProductListPageTile extends StatelessWidget {
  static const IconData chat =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const ProductListPageTile({
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
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.all(AppDefaults.padding),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Center(
              child: Stack(
                children: [
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
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
                                          height: 40,
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
                                        Positioned(
                                          top: 5,
                                          left: 55,
                                          child: Column(
                                            children: [
                                              Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.defaultBlack,
                                                ),
                                              ),
                                              Text(
                                                location,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.defaultBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Positioned(
                                          right: 0,
                                          child: Icon(
                                            chat,
                                            color: AppColors.primary,
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
                                  product,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Quantity: $quantity',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.defaultBlack,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.defaultBlack,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                            ],
                          ),
                        ),
                      )
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
