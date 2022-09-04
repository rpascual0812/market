import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/cards/big/big_card_image_slide.dart';
import 'package:market/screens/product/components/product_page_details.dart';
// import 'package:market/screens/product/product_page_copy.dart';

// import '../../components/network_image.dart';
// import '../../constants/app_defaults.dart';
// import 'components/color_picker.dart';
import 'package:market/demo_data.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({
    Key? key,
    this.isFavourite = false,
    required this.pk,
    required this.uuid,
    required this.title,
    required this.productImage,
    required this.quantity,
    required this.unit,
    required this.description,
    required this.location,
    required this.type,
    required this.createdBy,
    required this.userImage,
    required this.userName,
    required this.dateCreated,
  }) : super(key: key);

  final bool isFavourite;

  final int pk;
  final String uuid;
  final String title;
  final String productImage;
  final double quantity;
  final String unit;
  final String description;
  final String location;
  final String type;
  final int createdBy;
  final String userImage;
  final String userName;
  final DateTime dateCreated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Appbar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: BigCardImageSlide(images: demoBigImages),
            ),
            ProductPageDetails(
              pk: pk,
              uuid: uuid,
              title: title,
              productImage: productImage,
              quantity: quantity,
              unit: unit,
              description: description,
              location: location,
              type: type,
              createdBy: createdBy,
              userImage: userImage,
              userName: userName,
              dateCreated: dateCreated,
            ),
          ],
        ),
      ),
    );
  }
}
