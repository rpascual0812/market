import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/sliders/product_slider.dart';

import 'components/product_page_details.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({
    Key? key,
    this.isFavourite = false,
    required this.pk,
    required this.uuid,
    required this.type,
    required this.name,
    required this.description,
    required this.quantity,
    required this.priceFrom,
    required this.priceTo,
    required this.user,
    required this.measurement,
    required this.country,
    required this.userDocument,
    required this.productDocument,
    required this.dateCreated,
  }) : super(key: key);

  final bool isFavourite;

  final int pk;
  final String uuid;
  final String type; // looking for, future crop, already available
  final String name;
  final String description;
  final String quantity;
  final String priceFrom;
  final String priceTo;
  final Map<String, dynamic> user;
  final Map<String, dynamic> measurement;
  final Map<String, dynamic> country;
  final List userDocument;
  final List productDocument;
  final DateTime dateCreated;

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
                child: ProductSlider(documents: productDocument),
              ),
              ProductPageDetails(
                pk: pk,
                uuid: uuid,
                type: type,
                name: name,
                description: description,
                quantity: quantity,
                priceFrom: priceFrom,
                priceTo: priceTo,
                user: user,
                measurement: measurement,
                country: country,
                userDocument: userDocument,
                productDocument: productDocument,
                dateCreated: dateCreated,
              ),
              // const OtherProducts(
              //     title: 'Products from the shop', theme: 'white'),
              // const OtherProducts(title: 'Similar Products', theme: 'primary'),
            ],
          ),
        ),
      ),
    );
  }
}
