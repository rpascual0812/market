import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';

import 'package:market/models/product.dart';
import 'package:market/screens/looking_for/looking_for_page_tile.dart';

class RecentlyViewedPage extends StatefulWidget {
  const RecentlyViewedPage({Key? key}) : super(key: key);

  @override
  State<RecentlyViewedPage> createState() => _RecentlyViewedPageState();
}

class _RecentlyViewedPageState extends State<RecentlyViewedPage> {
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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();

    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Text(
                            'Recently viewed Products',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return LookingForPageTile(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
