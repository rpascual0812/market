import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/profile/components/follower_list.dart';
import 'package:market/screens/profile/components/following_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class ProfilePictureSection extends StatefulWidget {
  const ProfilePictureSection({
    Key? key,
    required this.user,
    required this.self,
  }) : super(key: key);

  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  final Map<String, dynamic> user;
  final bool self;

  @override
  State<ProfilePictureSection> createState() => _ProfilePictureSectionState();
}

class _ProfilePictureSectionState extends State<ProfilePictureSection> {
  Future getUser() async {
    final result = await storage.containsKey(key: 'jwt');
    log(result.toString());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userImage = AppDefaults.userImage(widget.user['user_document']);
    var userAddress = AppDefaults.userAddress(widget.user['user_addresses']);
    var sellerAddress =
        AppDefaults.sellerAddress(widget.user['seller_addresses']);

    Future follow(int pk) async {
      getUser();
      log(pk.toString());
    }

    return Stack(
      children: [
        Container(
          width: size.width,
          height: 340,
          color: AppColors.secondary,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(userImage),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.user['first_name']} ${widget.user['last_name']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                      height: AppDefaults.margin / 2),
                                  Visibility(
                                    visible: widget.self ? false : true,
                                    maintainSize: true, //NEW
                                    maintainAnimation: true, //NEW
                                    maintainState: true, //NEW
                                    child: Container(
                                      width: 90.0,
                                      height: 25.0,
                                      padding: EdgeInsets.zero,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          follow(widget.user['pk']);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppDefaults.radius),
                                          ),
                                          side: const BorderSide(
                                              width: 1, color: Colors.white),
                                        ),
                                        child: const Text(
                                          '+ Follow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  AppDefaults.fontSize + 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                              AppColors.gradient2,
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
                                        builder: (_) => const FollowingList());
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
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          widget.user['following_count']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: AppDefaults.fontSize,
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Following',
                                          style: TextStyle(
                                            fontSize: AppDefaults.fontSize,
                                            color: Colors.white,
                                          ),
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
                                        builder: (_) => const FollowerList());
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
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          widget.user['follower_count']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: AppDefaults.fontSize,
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          'Followers',
                                          style: TextStyle(
                                            fontSize: AppDefaults.fontSize,
                                            color: Colors.white,
                                          ),
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
                      children: [
                        const Icon(
                          ProfilePictureSection.pin,
                          size: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 320,
                          child: Text(
                            sellerAddress['city'] != null
                                ? '${sellerAddress['address']}, ${sellerAddress['city']['name']} ${sellerAddress['province']['name']}'
                                : '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDefaults.height / 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 320,
                          child: Text(
                            widget.user['seller']['mobile_number'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
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
