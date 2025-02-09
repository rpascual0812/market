import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({
    super.key,
    required this.width,
    this.thickness = 1,
  });

  final double width;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: thickness,
      color: Colors.grey,
    );
  }
}
