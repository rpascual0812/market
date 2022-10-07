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
            // shape: RoundedRectangleBorder(
            //   // side: const BorderSide(width: 1),
            //   borderRadius: AppDefaults.borderRadius,
            // ),
            child: InkWell(
              onTap: onTap,
              // borderRadius: AppDefaults.borderRadius,
              child: Container(
                decoration: const BoxDecoration(
                  // borderRadius: AppDefaults.borderRadius,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 220,
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
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 130,
                        height: 25,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          color: Colors.black45,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: const Text(
                            'Read Article',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDefaults.fontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDefaults.margin / 2),
          Text(
            name,
            style: const TextStyle(
              fontSize: AppDefaults.fontSize,
              color: AppColors.primary,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
