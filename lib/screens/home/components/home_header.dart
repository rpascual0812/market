import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/components/appbar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
    this.backButton,
  }) : super(key: key);

  final Widget? backButton;

  @override
  Widget build(BuildContext context) {
    return Appbar();
  }
}
