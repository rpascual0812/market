import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductSliderSlide extends StatelessWidget {
  const ProductSliderSlide({
    Key? key,
    required this.productDocuments,
  }) : super(key: key);

  final Map<String, dynamic> productDocuments;

  @override
  Widget build(BuildContext context) {
    var background = '${dotenv.get('API')}/assets/images/no-image.jpg';
    background = productDocuments['document']['path'] == ''
        ? background
        : '${dotenv.get('API')}/${productDocuments['document']['path']}';

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
