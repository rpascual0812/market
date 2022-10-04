import 'package:flutter/material.dart';
import 'package:market/constants/index.dart';
import 'sliders/small_dot.dart';

// import '../constants.dart';

class PriceRangeAndFoodtype extends StatelessWidget {
  const PriceRangeAndFoodtype({
    Key? key,
    this.priceRange = "\$\$",
    required this.marketType,
  }) : super(key: key);

  final String priceRange;
  final List<String> marketType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(priceRange, style: kBodyTextStyle),
        ...List.generate(
          marketType.length,
          (index) => Row(
            children: [
              buildSmallDot(),
              Text(marketType[index], style: kBodyTextStyle),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildSmallDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20 / 2),
      child: SmallDot(),
    );
  }
}
