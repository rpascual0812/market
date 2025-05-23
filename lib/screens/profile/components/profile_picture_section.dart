import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constants/index.dart';
import '../../auth/profile_edit_page.dart';
import 'follower_list.dart';
import 'following_list.dart';

const storage = FlutterSecureStorage();

class ProfilePictureSection extends StatefulWidget {
  const ProfilePictureSection({super.key});

  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  State<ProfilePictureSection> createState() => _ProfilePictureSectionState();
}

class _ProfilePictureSectionState extends State<ProfilePictureSection> {
  Map<String, dynamic> user = {};
  String? token = '';

  @override
  void initState() {
    super.initState();

    getStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getStorage() async {
    token = await storage.read(key: 'jwt');
    fetch();
  }

  Future fetch() async {
    try {
      var account = AppDefaults.jwtDecode(token);
      int accountPk = account['sub'];
      // print('${dotenv.get('API')}/accounts/$accountPk');
      // print(token);
      final url = Uri.parse('${dotenv.get('API')}/accounts/$accountPk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          var userJson = jsonDecode(res.body);
          user = userJson['user'];
        });
      }
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('S3')}/images/user.png';
    if (user['user_document'] != null) {
      userImage = AppDefaults.userImage(user['user_document']);
    }

    var userAddress = {};
    if (user['user_addresses'] != null) {
      var defaultFound = false;
      for (var i = 0; i < user['user_addresses'].length; i++) {
        if (user['user_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = user['user_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress =
            user['user_addresses'].length > 0 ? user['user_addresses'][0] : {};
      }

      // userAddress = AppDefaults.userAddress(user['user_addresses']);
    }
    // print(userAddress);
    // var sellerAddress = {};
    // if (user['seller_addresses'] != null) {
    //   sellerAddress = AppDefaults.sellerAddress(user['seller_addresses']);
    // }

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
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
                        radius: MediaQuery.of(context).size.height * 0.04,
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
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user['first_name']} ${user['last_name']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                      height: AppDefaults.margin / 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEditPage(
                                                    user: user,
                                                    callback: () {
                                                      fetch();
                                                    }),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Edit Profile',
                                        style: TextStyle(color: Colors.black38),
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
                                        builder: (_) => FollowingList(
                                            userPk: user['pk'],
                                            token: token ?? ''));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 8,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          user['following_count'].toString(),
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
                                      builder: (_) => FollowerList(
                                        userPk: user['pk'],
                                        token: token ?? '',
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 8,
                                    ),
                                    margin: const EdgeInsets.all(0),
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          user['follower_count'].toString(),
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
                            userAddress['city'] != null
                                ? '${userAddress['address']}, ${userAddress['city']['name']} ${userAddress['province']['name']}'
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
                            user['mobile_number'] ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
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
                      children: [
                        SizedBox(
                          width: 320,
                          child: Text(
                            user['about'] ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
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
