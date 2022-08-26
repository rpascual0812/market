import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/profile/components/follower_list.dart';
import 'package:market/screens/profile/components/following_list.dart';
import '../../../size_config.dart';

import '../../../constants/app_images.dart';
import 'custom_background_profile.dart';

class ProfilePictureSection extends StatelessWidget {
  const ProfilePictureSection({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // CustomPaint(
        //   size: Size(size.width, (size.width * 0.5625).toDouble()),
        //   painter: CustomPaintBackground(),
        // ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          color: AppColors.secondary,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const CachedNetworkImageProvider(
                        'https://i.imgur.com/8G2bg5J.jpeg'),
                    radius: size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 5.0),
                    child: Material(
                      color: Colors.transparent,
                      // color: Colors.white,
                      child: InkWell(
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(AppDefaults.padding),
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: const Text(
                            'Raffier Lee',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 5.0,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => FollowingList());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                width: MediaQuery.of(context).size.width * 0.19,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    SizedBox(height: 5),
                                    Text(
                                      '100',
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => FollowerList());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                margin: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.19,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    SizedBox(height: 5),
                                    Text(
                                      '2',
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
