import 'package:flutter/material.dart';

import '../constants/index.dart';

class SectionDividerTitle extends StatelessWidget {
  const SectionDividerTitle({
    super.key,
    required this.title,
    this.buttonTitle,
    this.onTap,
  });

  final String title;
  final String? buttonTitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: AppDefaults.fontSize + 5,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              InkWell(
                onTap: onTap,
                child: const Text('see more'),
              ),
              InkWell(
                onTap: onTap,
                child: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          // TextButton(
          //   onPressed: onTap,
          //   child: Text(
          //     buttonTitle ?? 'See All',
          //     style: Theme.of(context)
          //         .textTheme
          //         .bodyText1
          //         ?.copyWith(color: Colors.grey),
          //   ),
          // )
        ],
      ),
    );
  }
}
