import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductSliderSlide extends StatelessWidget {
  const ProductSliderSlide({
    Key? key,
    required this.pk,
    required this.userPk,
    required this.productPk,
    required this.type,
    required this.documentPk,
    required this.dateCreated,
    required this.document,
  }) : super(key: key);

  final int? pk;
  final int userPk;
  final int productPk;
  final String type;
  final int documentPk;
  final DateTime dateCreated;
  final Map<String, dynamic> document;

  @override
  Widget build(BuildContext context) {
    var background = '${dotenv.get('API')}/${document['path']}';

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
