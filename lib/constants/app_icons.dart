import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market/constants/app_colors.dart';

class AppIcons {
  static SvgPicture homeInactive = SvgPicture.asset(
    'assets/icons/home.svg',
    color: AppColors.secondary,
    width: 30,
  );

  static SvgPicture homeActive = SvgPicture.asset(
    'assets/icons/home-selected.svg',
    color: AppColors.primary,
    width: 30,
  );

  static SvgPicture newspaperInactive = SvgPicture.asset(
    'assets/icons/newspaper.svg',
    color: AppColors.secondary,
    width: 30,
  );

  static SvgPicture newspaperActive = SvgPicture.asset(
    'assets/icons/newspaper-selected.svg',
    color: AppColors.primary,
    width: 30,
  );

  static SvgPicture chatInactive = SvgPicture.asset(
    'assets/icons/messenger-white.svg',
    color: AppColors.secondary,
    width: 30,
  );

  static SvgPicture chatActive = SvgPicture.asset(
    'assets/icons/messenger-white.svg',
    color: AppColors.primary,
    width: 30,
  );

  static SvgPicture searchWhite = SvgPicture.asset(
    'assets/icons/search-white.svg',
    color: Colors.white,
    width: 25,
  );

  static SvgPicture shoppingBagWhite = SvgPicture.asset(
    'assets/icons/shoppingbag-green.svg',
    color: Colors.white,
    width: 25,
  );

  static SvgPicture shoppingBagCheckWhite = SvgPicture.asset(
    'assets/icons/shoppingbagcheck-green.svg',
    color: AppColors.primary,
    width: 50,
  );

  static SvgPicture bellWhite = SvgPicture.asset(
    'assets/icons/bell.svg',
    color: Colors.white,
    width: 25,
  );
}
