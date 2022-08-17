import 'package:flutter/material.dart';
// import 'package:market/components/cards/big/big_card_image.dart';
import 'package:market/components/cards/big/big_card_image_slide.dart';
import 'package:market/demoData.dart';
import 'package:market/screens/home/components/article_list.dart';
import 'package:market/screens/home/components/home_header.dart';
import 'package:market/size_config.dart';

import '../../constants/app_defaults.dart';
import 'components/home_new_arrival_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    this.backButton,
  }) : super(key: key);

  final Widget? backButton;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(backButton: backButton),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: BigCardImageSlide(images: demoBigImages),
            ),
            const SizedBox(height: AppDefaults.margin / 2),
            // const TitleAndSubtitle(),
            const SizedBox(height: AppDefaults.margin / 2),
            // const SearchBar(),
            const SizedBox(height: AppDefaults.margin / 2),
            const ArticleList(),
            const SizedBox(height: AppDefaults.margin / 2),
            const NewArrivalSection(),
          ],
        ),
      ),
    );
  }
}
