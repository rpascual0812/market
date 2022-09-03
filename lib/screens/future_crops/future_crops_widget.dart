import 'package:flutter/material.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/future_crops/future_crops_widget_tile.dart';

import '../../components/section_divider_title.dart';
// import '../../product/product_page.dart';

class FutureCropsWidget extends StatelessWidget {
  const FutureCropsWidget({
    Key? key,
  }) : super(key: key);

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
                  children: [
                    FutureCropsWidgetTile(
                      name: 'Juan Dela Cruz',
                      imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
                      product: 'Almonds',
                      quantity: '103 kg',
                      description: 'Lorem ipsum dolor sit amet',
                      location: 'Davao',
                      date: DateTime(2023, 08, 12, 13, 25),
                      onTap: () {},
                    ),
                    FutureCropsWidgetTile(
                      name: 'Long Sleeve Shirts',
                      imageLink: 'https://i.imgur.com/6AglEUF.jpeg',
                      product: 'Petchay',
                      quantity: '103 kg',
                      description: 'Lorem ipsum dolor sit amet',
                      location: 'Davao',
                      date: DateTime(2023, 08, 12, 13, 25),
                      onTap: () {},
                    ),
                    FutureCropsWidgetTile(
                      name: 'Long Sleeve Shirts',
                      imageLink: 'https://i.imgur.com/HU17L0b.png',
                      product: 'Banana',
                      quantity: '103 kg',
                      description: 'Lorem ipsum dolor sit amet',
                      location: 'Naga',
                      date: DateTime(2023, 08, 12, 13, 25),
                      onTap: () {},
                    ),
                    FutureCropsWidgetTile(
                      name: 'Long Sleeve Shirts',
                      imageLink: 'https://i.imgur.com/YzaqJlD.jpeg',
                      product: 'Strawberry',
                      quantity: '103 kg',
                      description: 'Lorem ipsum dolor sit amet',
                      location: 'Baguio',
                      date: DateTime(2023, 08, 12, 13, 25),
                      onTap: () {},
                    ),
                    FutureCropsWidgetTile(
                      name: 'Long Sleeve Shirts',
                      imageLink: 'https://i.imgur.com/l3gSyRn.jpeg',
                      product: 'Coffee',
                      quantity: '103 kg',
                      description: 'Lorem ipsum dolor sit amet',
                      location: 'Ilocos',
                      date: DateTime(2023, 08, 12, 13, 25),
                      onTap: () {},
                    ),
                    FutureCropsWidgetTile(
                      name: 'Casual Henley Shirts',
                      imageLink: 'https://i.imgur.com/pKgABuT.jpeg',
                      product: 'Mango',
                      quantity: '103 kg',
                      description: 'Lorem ipsum dolor sit amet',
                      location: 'Panay',
                      date: DateTime(2023, 08, 12, 13, 25),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const ProductPage(
                        //           coverImage: 'https://i.imgur.com/PFBRThN.png',
                        //         )));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
