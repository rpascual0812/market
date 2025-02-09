import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../size_config.dart';
import '../dot_indicators.dart';
import 'components/product_slider_slide.dart';

class ProductSlider extends StatefulWidget {
  const ProductSlider({super.key, required this.documents});

  final List documents;

  @override
  State<ProductSlider> createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  List productDocuments = [];
  int intialIndex = 0;
  final storage = const FlutterSecureStorage();
  String token = '';

  @override
  void initState() {
    super.initState();

    if (widget.documents.isEmpty) {
      widget.documents.add({
        'document': {'path': 'assets/images/no-image.jpg'}
      });
    }

    readStorage();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all ?? '';
      if (token != '') {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.21,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (value) {
              setState(() {
                intialIndex = value;
              });
            },
            itemCount: widget.documents.length,
            itemBuilder: (context, index) {
              return ProductSliderSlide(
                productDocuments: widget.documents[index],
              );
            },
          ),
          Positioned(
            bottom: getProportionateScreenWidth(15),
            right: (MediaQuery.of(context).size.width / 2) -
                (15 * widget.documents.length),
            child: Row(
              children: List.generate(
                widget.documents.length,
                (index) => DotIndicator(
                  isActive: intialIndex == index,
                  activeColor: Colors.white,
                  inActiveColor: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
