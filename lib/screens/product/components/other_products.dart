import 'package:flutter/material.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/models/product.dart';
import 'package:market/screens/product/product_page.dart';
// import '../../product/product_page.dart';

class OtherProducts extends StatelessWidget {
  OtherProducts({
    Key? key,
    required this.title,
    required this.theme,
  }) : super(key: key);

  final String title;
  final String theme;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      height: 360,
      color: theme == 'primary' ? AppColors.primary : Colors.white,
      // decoration: BoxDecoration(color: AppColors.primary),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      color:
                          theme == 'white' ? AppColors.primary : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 0),
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ProductListWidgetTileSquare(
                  pk: products[index].pk,
                  title: products[index].title,
                  price: 165,
                  productImage: products[index].productImage,
                  hasFavourite: true,
                  isFavourite: true,
                  ratings: 3.5,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          pk: products[index].pk,
                          uuid: products[index].uuid,
                          title: products[index].title,
                          productImage: products[index].productImage,
                          quantity: products[index].quantity,
                          unit: products[index].unit,
                          description: products[index].description,
                          location: products[index].location,
                          type: products[index].type,
                          createdBy: products[index].createdBy,
                          userImage: products[index].userImage,
                          userName: products[index].userName,
                          dateCreated: products[index].dateCreated,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  child: Text(
                    'View more',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
