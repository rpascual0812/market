import 'package:flutter/material.dart';

import 'constants/index.dart';

class AppTheme {
  final BuildContext context;
  AppTheme(this.context);

  /// Default Font Family Name
  final String _defaultFont = 'Roboto';

  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      colorScheme: ColorScheme.fromSwatch(accentColor: AppColors.primary),
      brightness: Brightness.light,
      fontFamily: _defaultFont,
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: _defaultFont,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 40),
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.all(AppDefaults.padding),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: AppDefaults.borderRadius,
          borderSide: BorderSide.none,
        ),
        // enabledBorder: defaultOutlineInputBorder,
        // focusedBorder: defaultOutlineInputBorder,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      appBarTheme: AppBarTheme(
        // backgroundColor: Colors.transparent,
        color: AppColors.defaultBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontFamily: 'Roboto'),
        iconTheme: const IconThemeData(color: AppColors.defaultBlack),
      ),
      buttonTheme: const ButtonThemeData(
        shape: StadiumBorder(),
        padding: EdgeInsets.all(16),
      ),
      sliderTheme: const SliderThemeData(
        thumbColor: AppColors.primary,
        activeTrackColor: AppColors.primary,
      ),
      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
