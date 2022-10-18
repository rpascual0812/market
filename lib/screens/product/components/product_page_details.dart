import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:market/components/network_image.dart';
import 'package:market/screens/chat/bubble.dart';
import 'package:market/screens/producer/producer_page/producer_page.dart';
import 'package:market/screens/product/components/rate_product_page.dart';
import 'package:market/screens/product/components/ratings_page.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

import '../../../constants/index.dart';
import '../../orders/order_page.dart';
// import 'color_picker.dart';

class ProductPageDetails extends StatefulWidget {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  const ProductPageDetails({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Map<String, dynamic> product;

  @override
  State<ProductPageDetails> createState() => _ProductPageDetailsState();
}

class _ProductPageDetailsState extends State<ProductPageDetails> {
  @override
  Widget build(BuildContext context) {
    // print('produc2t ${widget.product}');
    var userImage = widget.product['user_document'] == null
        ? '${dotenv.get('API')}/assets/images/no-image.jpg'
        : '${dotenv.get('API')}/${widget.product['user_document']['document']['path']}';

    return Container(
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
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product['name'] ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  children: [
                    Container(
                      width: 80.0,
                      height: 30.0,
                      padding: EdgeInsets.zero,
                      child: OutlinedButton(
                        onPressed: () async {
                          ArtDialogResponse response = await ArtSweetAlert.show(
                            barrierDismissible: false,
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                denyButtonText: "Cancel",
                                denyButtonColor: Colors.grey,
                                title: "Are you sure you want to buy this?",
                                confirmButtonText: "Confirm",
                                confirmButtonColor: AppColors.primary),
                          );

                          if (response.isTapConfirmButton) {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const OrderPage(type: 'orders');
                                },
                              ),
                            );
                          }

                          if (response.isTapDenyButton) {
                            return;
                          }
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
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 90.0,
                      height: 30.0,
                      padding: EdgeInsets.zero,
                      child: OutlinedButton(
                        onPressed: () async {
                          ArtDialogResponse response = await ArtSweetAlert.show(
                              barrierDismissible: false,
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                denyButtonText: "Ok",
                                denyButtonColor: Colors.grey,
                                title:
                                    "This product has been added to your cart",
                                confirmButtonText: "Go to Cart",
                              ));

                          if (response.isTapConfirmButton) {
                            ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                    type: ArtSweetAlertType.success,
                                    title: "Saved!"));
                            return;
                          }

                          if (response.isTapDenyButton) {
                            return;
                          }
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
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5)
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              '₱${widget.product['price_from'].toString()}',
              style: const TextStyle(
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
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RatingsPage(product: widget.product),
                  ),
                );
              },
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
                        rating: widget.product['product_rating_total'] != null
                            ? double.parse(widget
                                .product['product_rating_total']
                                .toString())
                            : 5.00,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 25.0,
                      ),
                      Text(
                        '(${widget.product['product_rating_count'].toString()})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Description
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: NetworkImageWithLoader(userImage, true),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 150,
                            height: 20,
                            child: Text(
                              widget.product['user'] != null
                                  ? '${widget.product['user']['first_name']} ${widget.product['user']['last_name']}'
                                  : '',
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
                              children: const [
                                Icon(
                                  ProductPageDetails.pin,
                                  size: 12,
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
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
                Row(
                  children: [
                    Container(
                      width: 35.0,
                      height: 30.0,
                      padding: EdgeInsets.zero,
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
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 1,
                            color: AppColors.primary,
                          ),
                          padding: const EdgeInsets.all(5),
                        ),
                        child: const Icon(
                          ProductPageDetails.chat,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 90.0,
                      height: 30.0,
                      padding: EdgeInsets.zero,
                      child: OutlinedButton(
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
                          padding: const EdgeInsets.all(0),
                        ),
                        child: const Text(
                          'View Shop',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5)
                  ],
                ),
              ],
            ),
          ),
          // const Spacer(),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: AppColors.grey1),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160.0,
                    height: 40.0,
                    padding: EdgeInsets.zero,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RateProductPage(product: widget.product);
                            },
                          ),
                        );
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
                        'Rate Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                Text(
                  'Product Details',
                  style: TextStyle(
                    fontSize: AppDefaults.fontSize + 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey2),
              ),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   child: Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: Row(
          //       children: const [
          //         SizedBox(
          //           width: 130,
          //           child: Text(
          //             'Product Posted',
          //             style: TextStyle(
          //               fontSize: 12,
          //             ),
          //           ),
          //         ),
          //         Text(
          //           'December 20, 2021',
          //           style: TextStyle(
          //             fontSize: 12,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: 130,
                      child: Text(
                        'Product Posted',
                        style: TextStyle(fontSize: AppDefaults.fontSize),
                      ),
                    ),
                  ),
                  Text(
                    widget.product['date_created'] != null
                        ? DateFormat('MMMM dd, yyyy').format(
                            DateTime.parse(widget.product['date_created']))
                        : '',
                    style: const TextStyle(
                      fontSize: AppDefaults.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: AppColors.secondary),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: 130,
                      child: Text(
                        'Ships From',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDefaults.fontSize),
                      ),
                    ),
                  ),
                  Text(
                    'Baguio, Benguet',
                    style: TextStyle(
                        color: Colors.white, fontSize: AppDefaults.fontSize),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(AppDefaults.margin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.product['description'] ?? '',
                      style: const TextStyle(
                        fontSize: AppDefaults.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
