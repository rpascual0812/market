import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/models/product.dart';
import '../../components/section_divider_title.dart';
import '../../constants/index.dart';
import 'future_crops_widget_tile.dart';
// import '../../product/product_page.dart';

class FutureCropsWidget extends StatefulWidget {
  const FutureCropsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FutureCropsWidget> createState() => _FutureCropsWidgetState();
}

class _FutureCropsWidgetState extends State<FutureCropsWidget> {
  List<Products> products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      var res = await Remote.get('products');
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            products.add(Products(
              pk: dataJson['data'][i]['pk'],
              uuid: dataJson['data'][i]['uuid'],
              type: dataJson['data'][i]['type'],
              name: dataJson['data'][i]['name'],
              description: dataJson['data'][i]['description'],
              quantity: dataJson['data'][i]['quantity'],
              priceFrom: dataJson['data'][i]['price_from'],
              priceTo: dataJson['data'][i]['price_to'],
              user: dataJson['data'][i]['user'],
              measurement: dataJson['data'][i]['measurement'],
              country: dataJson['data'][i]['country'],
              userDocument: dataJson['data'][i]['user_document'],
              productDocument: dataJson['data'][i]['product_document'],
              dateCreated: dataJson['data'][i]['date_created'],
            ));
            // print('products $products');
          }
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white70,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        borderRadius: AppDefaults.borderRadius,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            children: [
              SectionDividerTitle(
                title: 'Future Crops',
                onTap: () {},
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return FutureCropsWidgetTile(
                      pk: products[index].pk,
                      uuid: products[index].uuid,
                      user: products[index].user,
                      userDocument: products[index].userDocument,
                      productDocument: products[index].productDocument,
                      measurement: products[index].measurement,
                      name: products[index].name,
                      quantity: products[index].quantity,
                      description: products[index].description,
                      location: 'Palatiw, Pasig City',
                      date: products[index].dateCreated,
                      onTap: () {},
                    );
                  }),
                  // children: [
                  //   FutureCropsWidgetTile(
                  //     name: 'Juan Dela Cruz',
                  //     imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
                  //     product: 'Almonds',
                  //     quantity: '103 kg',
                  //     description: 'Lorem ipsum dolor sit amet',
                  //     location: 'Davao',
                  //     date: DateTime(2023, 08, 12, 13, 25),
                  //     onTap: () {},
                  //   ),
                  //   FutureCropsWidgetTile(
                  //     name: 'Long Sleeve Shirts',
                  //     imageLink: 'https://i.imgur.com/6AglEUF.jpeg',
                  //     product: 'Petchay',
                  //     quantity: '103 kg',
                  //     description: 'Lorem ipsum dolor sit amet',
                  //     location: 'Davao',
                  //     date: DateTime(2023, 08, 12, 13, 25),
                  //     onTap: () {},
                  //   ),
                  //   FutureCropsWidgetTile(
                  //     name: 'Long Sleeve Shirts',
                  //     imageLink: 'https://i.imgur.com/HU17L0b.png',
                  //     product: 'Banana',
                  //     quantity: '103 kg',
                  //     description: 'Lorem ipsum dolor sit amet',
                  //     location: 'Naga',
                  //     date: DateTime(2023, 08, 12, 13, 25),
                  //     onTap: () {},
                  //   ),
                  //   FutureCropsWidgetTile(
                  //     name: 'Long Sleeve Shirts',
                  //     imageLink: 'https://i.imgur.com/YzaqJlD.jpeg',
                  //     product: 'Strawberry',
                  //     quantity: '103 kg',
                  //     description: 'Lorem ipsum dolor sit amet',
                  //     location: 'Baguio',
                  //     date: DateTime(2023, 08, 12, 13, 25),
                  //     onTap: () {},
                  //   ),
                  //   FutureCropsWidgetTile(
                  //     name: 'Long Sleeve Shirts',
                  //     imageLink: 'https://i.imgur.com/l3gSyRn.jpeg',
                  //     product: 'Coffee',
                  //     quantity: '103 kg',
                  //     description: 'Lorem ipsum dolor sit amet',
                  //     location: 'Ilocos',
                  //     date: DateTime(2023, 08, 12, 13, 25),
                  //     onTap: () {},
                  //   ),
                  //   FutureCropsWidgetTile(
                  //     name: 'Casual Henley Shirts',
                  //     imageLink: 'https://i.imgur.com/pKgABuT.jpeg',
                  //     product: 'Mango',
                  //     quantity: '103 kg',
                  //     description: 'Lorem ipsum dolor sit amet',
                  //     location: 'Panay',
                  //     date: DateTime(2023, 08, 12, 13, 25),
                  //     onTap: () {
                  //       // Navigator.of(context).push(MaterialPageRoute(
                  //       //     builder: (context) => const ProductPage(
                  //       //           coverImage: 'https://i.imgur.com/PFBRThN.png',
                  //       //         )));
                  //     },
                  //   ),
                  // ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
