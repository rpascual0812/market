import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/size_config.dart';

final TextStyle kSecondaryBodyTextStyle = TextStyle(
  fontSize: getProportionateScreenWidth(14),
  fontWeight: FontWeight.w500,
  color: AppColors.primary,
  // height: 1.5,
);

final TextStyle kSubHeadTextStyle = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.w500,
  color: AppColors.primary,
  letterSpacing: 0.44,
);

final TextStyle kBodyTextStyle = TextStyle(
  fontSize: getProportionateScreenWidth(16),
  color: AppColors.defaultBodyTextColor,
  height: 1.5,
);

final TextStyle kCaptionTextStyle = TextStyle(
  color: AppColors.primary.withOpacity(0.64),
  fontSize: getProportionateScreenWidth(12),
  fontWeight: FontWeight.w600,
);
