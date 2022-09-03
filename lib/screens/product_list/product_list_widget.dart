import 'package:flutter/material.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
import 'package:market/models/product.dart';
// import 'package:market/constants/app_defaults.dart';

// import '../../product/product_page.dart';

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  List<Products> products = [
    Products(
      pk: 1,
      uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
      title: 'Looking for Almonds',
      productImage: '',
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
      title: 'Looking for Banana Supplier',
      productImage: '',
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
      title: 'Looking for Almonds Supplier',
      productImage: '',
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
      title: 'Looking for Almonds',
      productImage: '',
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
      title: 'Looking for Banana Supplier',
      productImage: '',
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
      productImage: '',
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
      productImage: '',
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
      productImage: '',
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
      productImage: '',
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
    return ListView.builder(
      itemCount: products.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ProductListWidgetTileSquare(
          pk: products[index].pk,
          title: 'Banana',
          price: 165,
          imageLink: 'https://i.imgur.com/R3Cpn1T.jpeg',
          hasFavourite: true,
          isFavourite: true,
          ratings: 3.5,
          onTap: () {},
        );
      },
    );
    // return ListView(
    //   shrinkWrap: true,
    //   physics: const ScrollPhysics(),
    //   children: <Widget>[
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: AppDefaults.margin),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: const [
    //               Padding(
    //                 padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
    //                 child: Text(
    //                   'Product Post',
    //                   style: TextStyle(
    //                       color: AppColors.primary,
    //                       fontSize: 18,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           TextButton(
    //             onPressed: () {},
    //             child: Container(
    //               height: 25,
    //               padding:
    //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //               decoration: const BoxDecoration(
    //                 color: AppColors.secondary,
    //                 // borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: DropdownButton(
    //                 style: const TextStyle(color: Colors.white, fontSize: 10),
    //                 value: filterValue,
    //                 icon: const Icon(
    //                   Icons.keyboard_arrow_down,
    //                   size: 12,
    //                   color: Colors.white,
    //                 ),
    //                 underline: const SizedBox(),
    //                 items: filters.map((String items) {
    //                   return DropdownMenuItem(
    //                     value: items,
    //                     child: Text(
    //                       items,
    //                       style: const TextStyle(color: AppColors.secondary),
    //                     ),
    //                   );
    //                 }).toList(),
    //                 onChanged: (String? newValue) {
    //                   setState(() {
    //                     filterValue = newValue!;
    //                   });
    //                 },
    //                 selectedItemBuilder: (BuildContext ctxt) {
    //                   return filters.map<Widget>((item) {
    //                     return DropdownMenuItem(
    //                       value: item,
    //                       child: Text(
    //                         item,
    //                         style: const TextStyle(color: Colors.white),
    //                       ),
    //                     );
    //                   }).toList();
    //                 },
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //     // const SizedBox(height: 20.0),
    //     ListView.builder(
    //       shrinkWrap: true,
    //       itemCount: (products.length / 2).ceil(),
    //       physics: const ScrollPhysics(),
    //       itemBuilder: (context, index) {
    //         return Column(
    //           children: <Widget>[
    //             SizedBox(
    //               height: 297.0,
    //               child: ListView.builder(
    //                 shrinkWrap: true,
    //                 scrollDirection: Axis.horizontal,
    //                 itemCount: 2,
    //                 itemBuilder: (context, verticalIndex) {
    //                   return ProductListWidgetTileSquare(
    //                     pk: products[index].pk,
    //                     title: products[index].title,
    //                     price: 165,
    //                     imageLink: 'https://i.imgur.com/R3Cpn1T.jpeg',
    //                     hasFavourite: true,
    //                     isFavourite: true,
    //                     ratings: 3.5,
    //                     onTap: () {},
    //                   );
    //                 },
    //               ),
    //             ),
    //             // const SizedBox(height: 20.0),
    //           ],
    //         );
    //       },
    //     ),
    //   ],
    // );

    // return Column(
    //   children: [
    //     SectionDividerTitle(
    //       title: 'Product Post',
    //       onTap: () {},
    //     ),
    //     SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: Row(
    //         children: [
    //           ProductListWidgetTileSquare(
    //             pk: 1,
    //             title: 'Banana',
    //             price: 165,
    //             imageLink: 'https://i.imgur.com/R3Cpn1T.jpeg',
    //             hasFavourite: true,
    //             isFavourite: true,
    //             ratings: 3.5,
    //             onTap: () {},
    //           ),
    //           ProductListWidgetTileSquare(
    //             pk: 2,
    //             title: 'Tomato',
    //             price: 165,
    //             imageLink: 'https://i.imgur.com/fFrzEcg.jpeg',
    //             hasFavourite: true,
    //             isFavourite: true,
    //             ratings: 5,
    //             onTap: () {},
    //           ),
    //           ProductListWidgetTileSquare(
    //             pk: 3,
    //             title: 'Banana',
    //             price: 165,
    //             imageLink: 'https://i.imgur.com/R3Cpn1T.jpeg',
    //             hasFavourite: true,
    //             isFavourite: false,
    //             ratings: 3.5,
    //             onTap: () {},
    //           ),
    //           ProductListWidgetTileSquare(
    //             pk: 4,
    //             title: 'Tomato',
    //             price: 165,
    //             imageLink: 'https://i.imgur.com/fFrzEcg.jpeg',
    //             hasFavourite: true,
    //             isFavourite: false,
    //             ratings: 5,
    //             onTap: () {},
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
