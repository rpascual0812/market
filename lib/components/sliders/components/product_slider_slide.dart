import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductSliderSlide extends StatelessWidget {
  const ProductSliderSlide({
    super.key,
    required this.productDocuments,
  });

  final Map<String, dynamic> productDocuments;

  @override
  Widget build(BuildContext context) {
    var background = '${dotenv.get('S3')}/images/no-image.png';
    background = productDocuments['document']['path'] == ''
        ? background
        : '${productDocuments['document']['path']}';

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(background),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
