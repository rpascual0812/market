import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        Align(
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
                    // color: Colors.white,
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        width: MediaQuery.of(context).size.width * 0.39,
                        child: const Text(
                          'Raffier Lee',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 5.0,
                  ),
                  child: Material(
                    // color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context, builder: (_) => FollowingList());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              '100',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: Colors.black54),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Following',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 5.0,
                  ),
                  child: Material(
                    // color: Colors.blue,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context, builder: (_) => FollowerList());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              '2',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: Colors.black54),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Followers',
                              style: TextStyle(fontSize: 10),
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
        )
      ],
    );
  }
}
