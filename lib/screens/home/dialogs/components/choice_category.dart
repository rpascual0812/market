import 'package:flutter/material.dart';

import '../../../../constants/index.dart';

class ChoiceCategory extends StatelessWidget {
  const ChoiceCategory({
    super.key,
    required this.onTap,
    required this.name,
    required this.isActive,
  });

  final void Function() onTap;
  final String name;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: isActive ? AppColors.primary : Colors.white,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: isActive ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
