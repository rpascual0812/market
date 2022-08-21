import 'package:flutter/material.dart';
import 'package:market/components/product_list_widget_tile_square.dart';
// import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/future_crops/future_crops_widget_tile.dart';

import '../../components/section_divider_title.dart';
// import '../../product/product_page.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionDividerTitle(
          title: 'Product Post',
          onTap: () {},
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ProductListWidgetTileSquare(
                pk: 1,
                title: 'Banana',
                price: 165,
                imageLink: 'https://i.imgur.com/R3Cpn1T.jpeg',
                hasFavourite: true,
                isFavourite: true,
                ratings: 3.5,
                onTap: () {},
              ),
              ProductListWidgetTileSquare(
                pk: 2,
                title: 'Tomato',
                price: 165,
                imageLink: 'https://i.imgur.com/fFrzEcg.jpeg',
                hasFavourite: true,
                isFavourite: true,
                ratings: 5,
                onTap: () {},
              ),
              ProductListWidgetTileSquare(
                pk: 3,
                title: 'Banana',
                price: 165,
                imageLink: 'https://i.imgur.com/R3Cpn1T.jpeg',
                hasFavourite: true,
                isFavourite: false,
                ratings: 3.5,
                onTap: () {},
              ),
              ProductListWidgetTileSquare(
                pk: 4,
                title: 'Tomato',
                price: 165,
                imageLink: 'https://i.imgur.com/fFrzEcg.jpeg',
                hasFavourite: true,
                isFavourite: false,
                ratings: 5,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
