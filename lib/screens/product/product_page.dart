import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/product/components/other_products.dart';

import '../../components/sliders/product_slider.dart';
import '../../constants/index.dart';
import 'components/product_page_details.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
    required this.productPk,
  }) : super(key: key);

  final int productPk;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Map<String, dynamic> product = <String, dynamic>{};
  @override
  void initState() {
    super.initState();

    fetch();
  }

  Future fetch() async {
    try {
      var res = await Remote.get('products/${widget.productPk}', {});
      if (res.statusCode == 200) {
        setState(() {
          var productJson = jsonDecode(res.body);
          product = productJson['data'];
        });
      }
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

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
