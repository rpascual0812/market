import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final storage = const FlutterSecureStorage();
  String? token = '';

  Map<String, dynamic> product = <String, dynamic>{};
  @override
  void initState() {
    super.initState();
    readStorage();
    fetch();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
    });
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
    var accountPk = '';
    if (product['user'] != null && product['user']['account'] != null) {
      accountPk = product['user']['account']['pk'].toString();
    }

    return Scaffold(
      appBar: const Appbar(),
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
              Visibility(
                visible: product['name'] != null ? true : false,
                child: ProductPageDetails(product: product),
              ),
              Visibility(
                visible: product['name'] != null ? true : false,
                child: OtherProducts(
                  userPk: product['user_pk'].toString(),
                  title: 'Products from this producer',
                  theme: 'white',
                  token: token!,
                  accountPk: accountPk.toString(),
                ),
              ),
              OtherProducts(
                title: 'Similar Products',
                theme: 'primary',
                token: token!,
                accountPk: accountPk.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
