// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// import '../../../constants/app_images.dart';
import 'custom_background_profile.dart';

class ProfilePictureSection extends StatelessWidget {
  const ProfilePictureSection({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(size.width, (size.width * 0.5625).toDouble()),
          painter: CustomPaintBackground(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  '\$1,000,000',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Text('Monthly Sales'),
              ],
            ),
            // child: CircleAvatar(
            //   backgroundImage:
            //       const CachedNetworkImageProvider(AppImages.userAvatar),
            //   radius: size.height * 0.1,
            // ),
          ),
        )
      ],
    );
  }
}
