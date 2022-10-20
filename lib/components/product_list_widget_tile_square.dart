// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants/index.dart';
import 'network_image.dart';

class ProductListWidgetTileSquare extends StatelessWidget {
  const ProductListWidgetTileSquare({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> product;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var image = '${dotenv.get('API')}/assets/images/no-image.jpg';

    for (var i = 0; i < product['product_documents'].length; i++) {
      // print(product['product_documents'][i]['document']['path']);
      if (product['product_documents'][i]['document']['path'] != null &&
          product['product_documents'][i]['default'] == true) {
        image =
            '${dotenv.get('API')}/${product['product_documents'][i]['document']['path']}';
      }
    }

    // var image = product['product_documents'].isEmpty
    //     ? '${dotenv.get('API')}/assets/images/no-image.jpg'
    //     : '${dotenv.get('API')}/${product['product_documents'][0]['document']['path']}';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppDefaults.borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10),
                width: (MediaQuery.of(context).size.width),
                height: 150,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: NetworkImageWithLoader(image, false),
                ),
              ),
              // const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product['name'],
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 2,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${product['country']['currency_symbol']}${product['price_from']}',
                        style: const TextStyle(
                            fontFamily: '',
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RatingBarIndicator(
                        rating: product['product_rating_total'] != null
                            ? double.parse(
                                product['product_rating_total'].toString())
                            : 0.00,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 15.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    //   child: Material(
    //     color: Colors.white,
    //     borderRadius: AppDefaults.borderRadius,
    //     child: InkWell(
    //       onTap: onTap,
    //       borderRadius: AppDefaults.borderRadius,
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.grey.withOpacity(0.3),
    //               spreadRadius: 5,
    //               blurRadius: 7,
    //               offset: const Offset(0, 0), // changes position of shadow
    //             ),
    //           ],
    //           borderRadius: AppDefaults.borderRadius,
    //         ),
    //         width: MediaQuery.of(context).size.width * 0.45,
    //         padding: const EdgeInsets.all(AppDefaults.padding),
    //         child: Center(
    //           child: Stack(
    //             children: [
    //               Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   SizedBox(
    //                     width: (MediaQuery.of(context).size.width),
    //                     height: 100,
    //                     child: AspectRatio(
    //                       aspectRatio: 1 / 1,
    //                       child: Hero(
    //                         tag: pk,
    //                         child: NetworkImageWithLoader(
    //                           productDocument,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(height: 8),
    //                   Column(
    //                     // mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Align(
    //                         alignment: Alignment.centerLeft,
    //                         child: Text(
    //                           name,
    //                           style: Theme.of(context).textTheme.bodyText2,
    //                           maxLines: 2,
    //                         ),
    //                       ),
    //                       const SizedBox(height: 8),
    //                       Align(
    //                         alignment: Alignment.centerLeft,
    //                         child: Text(
    //                           '\$${price.toInt()}',
    //                           style: const TextStyle(
    //                               color: AppColors.primary,
    //                               fontWeight: FontWeight.bold),
    //                           maxLines: 1,
    //                         ),
    //                       ),
    //                       const SizedBox(height: 8),
    //                       Align(
    //                         alignment: Alignment.centerLeft,
    //                         child: RatingBarIndicator(
    //                           rating: ratings,
    //                           itemBuilder: (context, index) => const Icon(
    //                             Icons.star,
    //                             color: Colors.amber,
    //                           ),
    //                           itemCount: 5,
    //                           itemSize: 15.0,
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),

    //               /// This will show only when hasFavourite parameter is true
    //               if (hasFavourite)
    //                 Positioned(
    //                   top: 8,
    //                   right: 8,
    //                   child: Container(
    //                     padding: const EdgeInsets.all(8.0),
    //                     decoration: const BoxDecoration(
    //                       shape: BoxShape.circle,
    //                       // color: Colors.white,
    //                     ),
    //                     child: Icon(
    //                       isFavourite ? IconlyBold.heart : IconlyLight.heart,
    //                       color: Colors.red,
    //                     ),
    //                   ),
    //                 ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
