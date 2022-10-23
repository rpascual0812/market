import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/profile/components/follower_list.dart';
import 'package:market/screens/profile/components/following_list.dart';

class ProfilePictureSection extends StatelessWidget {
  const ProfilePictureSection({
    Key? key,
    required this.size,
  }) : super(key: key);

  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

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
          height: 305,
          color: AppColors.secondary,
          child: Column(
            children: [
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
                          color: Colors.transparent,
                          // color: Colors.white,
                          child: InkWell(
                            child: Container(
                              color: Colors.transparent,
                              padding:
                                  const EdgeInsets.all(AppDefaults.padding),
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
                                        builder: (_) => const FollowingList(
                                              userPk: 4,
                                              token: '',
                                            ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 8,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
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
                                        builder: (_) => const FollowerList(
                                              userPk: 4,
                                              token: '',
                                            ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 8,
                                    ),
                                    margin: const EdgeInsets.all(0),
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
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
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.95,
                height: 200,
                color: AppColors.third,
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          pin,
                          size: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 320,
                          child: Text(
                            'Belmonte Stree Corner Aruego Street near Public Market, Urdaneta, Pangasinan',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(
                          Icons.phone,
                          size: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 320,
                          child: Text(
                            '091234567890',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        SizedBox(
                          width: 320,
                          child: Text(
                            'About:',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 320,
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }
}
