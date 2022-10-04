import 'package:flutter/material.dart';
import 'package:market/constants/index.dart';

// import '../../constants.dart';
import '../../size_config.dart';
import '../sliders/small_dot.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.marketType,
    required this.price,
    required this.priceRange,
    required this.press,
  }) : super(key: key);

  final String? title, description, image, marketType, priceRange;
  final double? price;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = kSecondaryBodyTextStyle.copyWith(
      color: AppColors.primary.withOpacity(0.64),
      fontWeight: FontWeight.normal,
    );
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: getProportionateScreenWidth(110),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.asset(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const HorizontalSpacing(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      maxLines: 1,
                      style: kSubHeadTextStyle.copyWith(
                          fontSize: getProportionateScreenWidth(18)),
                    ),
                    Text(
                      description!,
                      style: kBodyTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          priceRange!,
                          style: textStyle,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(5)),
                          child: const SmallDot(),
                        ),
                        Text(marketType!, style: textStyle),
                        const Spacer(),
                        Text(
                          "USD$price",
                          style: kSecondaryBodyTextStyle.copyWith(
                              color: AppColors.primary),
                        )
                      ],
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
