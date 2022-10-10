// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/screens/chat/bubble.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';
import '../screens/producer/producer_page/producer_page.dart';

class FutureCropsPageTile extends StatelessWidget {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const FutureCropsPageTile({
    Key? key,
    required this.pk,
    required this.profilePhoto,
    required this.name,
    required this.product,
    required this.quantity,
    required this.date,
    required this.price,
    required this.location,
    required this.productPhoto,
    this.onTap,
    this.hasFavourite = false,
    this.isFavourite = false,
    this.onFavouriteClicked,
  }) : super(key: key);

  final int pk;
  final String profilePhoto;
  final String name;
  final String product;
  final String quantity;
  final String date;
  final String price;
  final String location;
  final String productPhoto;
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
            height: 310,
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
                                                profilePhoto, true),
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
                                                  height: 20,
                                                  child: Text(
                                                    name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10),
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
                                                        pin,
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        location,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: AppColors
                                                              .defaultBlack,
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
                                              Container(
                                                width: 35.0,
                                                height: 35.0,
                                                padding: EdgeInsets.zero,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Bubble()));
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      width: 1,
                                                      color: AppColors.primary,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                  ),
                                                  child: const Icon(
                                                    chat,
                                                    color: AppColors.primary,
                                                    size: 15,
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
                                                        return const ProducerPage();
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
                                  date,
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
                                  price,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.defaultBlack,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDefaults.margin / 10),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: 150,
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: NetworkImageWithLoader(
                                      productPhoto, true),
                                ),
                              ),
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
