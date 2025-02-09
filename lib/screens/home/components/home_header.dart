import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.backButton,
  });

  final Widget? backButton;

  @override
  Widget build(BuildContext context) {
    return const Appbar();
  }
}
