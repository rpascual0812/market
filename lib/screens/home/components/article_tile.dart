import 'package:flutter/material.dart';

import '../../../components/network_image.dart';
import '../../../constants/index.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    Key? key,
    required this.name,
    required this.coverImage,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String coverImage;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.margin / 2),
      child: Column(
        children: [
          Material(
            color: Colors.white,
            // borderRadius: AppDefaults.borderRadius,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.01),
              borderRadius: AppDefaults.borderRadius,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: AppDefaults.borderRadius,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 200,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: NetworkImageWithLoader(
                          coverImage,
                          true,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDefaults.margin / 2),
          Text(
            name,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
