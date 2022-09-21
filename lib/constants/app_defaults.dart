import 'package:flutter/material.dart';

class AppDefaults {
  static const double radius = 12.00;
  static const double margin = 16.00;
  static const double padding = 16.00;
  static const double fontSize = 12.00;
  static const double height = 40.00;

  static BorderRadius borderRadius = BorderRadius.circular(radius);

  /// Many Parts of the UI uses this same box shadows
  static List<BoxShadow> boxShadows = [
    BoxShadow(
      blurRadius: 15,
      offset: const Offset(5, 4),
      color: const Color(0x0ff33333).withOpacity(0.05),
    )
  ];

  static displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
