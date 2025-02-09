import 'package:flutter/material.dart';
import 'package:market/constants/app_icons.dart';

import '../constants/index.dart';

class IconWithBackground extends StatelessWidget {
  static const IconData box =
      IconData(0xe806, fontFamily: 'Custom', fontPackage: null);

  const IconWithBackground({
    super.key,
    required this.iconData,
    this.color,
    this.iconColor,
    this.onTap,
    this.size,
    this.radius,
  });

  final String iconData;
  final Color? color;
  final Color? iconColor;
  final double? size;
  final void Function()? onTap;
  final BorderRadiusGeometry? radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: radius ?? const BorderRadius.all(Radius.circular(8.0)),
        // color: color ?? AppColors.primary.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: iconData == 'box'
                ? Icon(box, color: iconColor ?? AppColors.primary, size: 65)
                : AppIcons.shoppingBagCheckWhite,
          ),
        ),
      ),
    );
  }
}
