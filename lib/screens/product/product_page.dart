import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/product/components/other_products.dart';

import '../../components/sliders/product_slider.dart';
import 'components/product_page_details.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ProductSlider(
                    documents: product['product_documents'] ?? []),
              ),
              ProductPageDetails(product: product),
              const OtherProducts(
                  title: 'Products from the shop', theme: 'white'),
              const OtherProducts(title: 'Similar Products', theme: 'primary'),
            ],
          ),
        ),
      ),
    );
  }
}
