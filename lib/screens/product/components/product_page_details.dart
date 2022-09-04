import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/network_image.dart';
import 'package:market/constants/app_colors.dart';

import '../../../constants/app_defaults.dart';
// import 'color_picker.dart';

class ProductPageDetails extends StatelessWidget {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const ProductPageDetails({
    Key? key,
    this.isFavourite = false,
    required this.pk,
    required this.uuid,
    required this.title,
    required this.productImage,
    required this.quantity,
    required this.unit,
    required this.description,
    required this.location,
    required this.type,
    required this.createdBy,
    required this.userImage,
    required this.userName,
    required this.dateCreated,
  }) : super(key: key);

  final bool isFavourite;

  final int pk;
  final String uuid;
  final String title;
  final String productImage;
  final double quantity;
  final String unit;
  final String description;
  final String location;
  final String type;
  final int createdBy;
  final String userImage;
  final String userName;
  final DateTime dateCreated;

  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDefaults.radius),
            topRight: Radius.circular(AppDefaults.radius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Title And Pricing
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return const Bubble();
                          //     },
                          //   ),
                          // );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 1,
                            color: AppColors.primary,
                          ),
                          padding: const EdgeInsets.all(5),
                        ),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      OutlinedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return const Bubble();
                          //     },
                          //   ),
                          // );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          side: const BorderSide(
                            width: 1,
                            color: AppColors.primary,
                          ),
                          padding: const EdgeInsets.all(5),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5)
                    ],
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '₱175',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'View Ratings',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: 4,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 25.0,
                      ),
                      const Text(
                        '(265)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Description
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  SizedBox(
                    height: 45,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Hero(
                        tag: pk,
                        child: NetworkImageWithLoader(userImage, true),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: 150,
                          height: 20,
                          child: Text(
                            userName,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: 150,
                          height: 20,
                          child: Row(
                            children: [
                              const Icon(
                                pin,
                                size: 12,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Color Choosers
            // const ColorPicker(),
            const Spacer(),

            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.8,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: const Text('Add To Cart'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
