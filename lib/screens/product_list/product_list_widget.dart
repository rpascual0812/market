import 'package:flutter/material.dart';
// import 'package:market/constants/app_colors.dart';
// import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/models/product.dart';

import '../../components/product_list_widget_tile_square.dart';
// import 'package:market/constants/app_defaults.dart';

// import '../../product/product_page.dart';

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final List<Products> products = [
    Products(
      pk: 1,
      uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
      title: 'Almonds',
      productImage: 'https://i.imgur.com/zdLsFZ0.jpeg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Palatiw, Pasig City',
      type: 'looking',
      createdBy: 1,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Raffier Lee',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 2,
      uuid: 'a21a82a0-7225-4c3c-b5f3-52ad16f68ca5',
      title: 'Banana',
      productImage: 'https://i.imgur.com/R3Cpn1T.jpeg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Pinagbuhatan, Pasig City',
      type: 'looking',
      createdBy: 2,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 3,
      uuid: '40221260-267a-11ed-a261-0242ac120002',
      title: 'Mango',
      productImage: 'https://i.imgur.com/IKDMrufb.jpg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Sagad, Pasig City',
      type: 'looking',
      createdBy: 3,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 4,
      uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
      title: 'Rice',
      productImage: 'https://i.imgur.com/3P3UxGeb.jpg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Palatiw, Pasig City',
      type: 'looking',
      createdBy: 1,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 5,
      uuid: 'a21a82a0-7225-4c3c-b5f3-52ad16f68ca5',
      title: 'Tomato',
      productImage: 'https://i.imgur.com/J0EgsIWb.jpg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Pinagbuhatan, Pasig City',
      type: 'looking',
      createdBy: 2,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 6,
      uuid: '40221260-267a-11ed-a261-0242ac120002',
      title: 'Looking for Almonds Supplier',
      productImage: 'https://i.imgur.com/R3Cpn1T.jpeg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Sagad, Pasig City',
      type: 'looking',
      createdBy: 3,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 7,
      uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
      title: 'Looking for Almonds',
      productImage: 'https://i.imgur.com/zdLsFZ0.jpeg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Palatiw, Pasig City',
      type: 'looking',
      createdBy: 1,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 8,
      uuid: 'a21a82a0-7225-4c3c-b5f3-52ad16f68ca5',
      title: 'Looking for Banana Supplier',
      productImage: 'https://i.imgur.com/R3Cpn1T.jpeg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Pinagbuhatan, Pasig City',
      type: 'looking',
      createdBy: 2,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Products(
      pk: 9,
      uuid: '40221260-267a-11ed-a261-0242ac120002',
      title: 'Looking for Almonds Supplier',
      productImage: 'https://i.imgur.com/zdLsFZ0.jpeg',
      quantity: 103,
      unit: 'kg',
      description: 'Lorem ipsum dolor sit amet',
      location: 'Sagad, Pasig City',
      type: 'looking',
      createdBy: 3,
      userImage: 'https://i.imgur.com/8G2bg5J.jpeg',
      userName: 'Juan Dela Cruz',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
  ];

  var filterValue = 'Lowest Price';
  var filters = [
    'Best Seller',
    'Newest',
    'Highest Price',
    'Lowest Price',
    'Average Rating',
    'Vegetables',
    'Fruits',
    'Seeds',
    'Herbs',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.68,
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductListWidgetTileSquare(
                pk: products[index].pk,
                title: products[index].title,
                price: 165,
                productImage: products[index].productImage,
                hasFavourite: true,
                isFavourite: true,
                ratings: 3.5,
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
