import 'package:flutter/material.dart';
import 'package:market/constants/app_imports.dart';

// import '../../../constants.dart';
import '../../../size_config.dart';
// import '../../rating.dart';
// import '../../small_dot.dart';

class RestaurantInfoMediumCard extends StatelessWidget {
  const RestaurantInfoMediumCard({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    required this.delivertTime,
    required this.press,
  });

  final String? image, name, location;
  final double rating;
  final int delivertTime;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(110),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                image!,
                fit: BoxFit.fill,
                width: 100,
                height: 200,
              ),
            ),
            Text(
              name!,
              maxLines: 1,
              style: kBodyTextStyle,
            ),
            const VerticalSpacing(of: 10),
          ],
        ),
      ),
    );
  }
}
