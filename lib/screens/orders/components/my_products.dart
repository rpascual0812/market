import 'package:flutter/material.dart';
import 'package:market/models/product.dart';
import 'package:market/screens/orders/components/my_product_tile.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  bool includeFutureCrops = false;

  List<Products> products = [
    Products(
      pk: 1,
      uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
      title: 'Banana',
      productImage: 'https://i.imgur.com/R3Cpn1T.jpeg',
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
      uuid: '5118a0b2-2679-11ed-a261-0242ac120002',
      title: 'Tomato',
      productImage: 'https://i.imgur.com/fFrzEcg.jpeg',
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
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.98,
          height: 50,
          child: Row(
            children: [
              Switch(
                value: includeFutureCrops,
                onChanged: (value) {
                  setState(() {
                    includeFutureCrops = value;
                  });
                },
              ),
              InkWell(
                child: const Text(
                  'Include Future Crops',
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  setState(() {
                    includeFutureCrops = !includeFutureCrops;
                  });
                },
              )
            ],
          ),
        ),
        // const SizedBox(height: 10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                // padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return MyProductTile(
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
      ],
    );
  }
}