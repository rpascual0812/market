import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/screens/profile/components/follower_list.dart';
import 'package:market/screens/profile/components/following_list.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class ProfilePictureSection extends StatefulWidget {
  const ProfilePictureSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> user;

  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  State<ProfilePictureSection> createState() => _ProfilePictureSectionState();
}

class _ProfilePictureSectionState extends State<ProfilePictureSection> {
  Map<String, dynamic> isFollowed = {};
  String? token = '';
  Map<String, dynamic> account = {};

  @override
  void initState() {
    super.initState();

    getStorage();
    checkIfFollowed();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getStorage() async {
    token = await storage.read(key: 'jwt');
    var user = AppDefaults.jwtDecode(token);
    fetchAccount(user['sub']);
  }

  Future fetchAccount(int pk) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$pk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          account = json.decode(res.body);
          print('account ${account['user']}');
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  Future follow() async {
    final user = AppDefaults.jwtDecode(token);

    try {
      final url = Uri.parse('${dotenv.get('API')}/users/follow');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      String follow = isFollowed.isNotEmpty ? 'unfollow' : 'follow';
      final body = {'user_pk': widget.user['pk'].toString(), 'follow': follow};

      var res = await http.post(url, headers: headers, body: body);
      if (res.statusCode == 201) {
        final result = json.decode(res.body);
        setState(() {
          follow == 'follow' ? checkIfFollowed() : isFollowed = {};
        });
      }
      // if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      return null;
    }
  }

  Future checkIfFollowed() async {
    final token = await storage.read(key: 'jwt');
    final user = AppDefaults.jwtDecode(token!);

    if (user != null) {
      try {
        final url = Uri.parse('${dotenv.get('API')}/users/followedByUser');
        final headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        final body = {'user_pk': widget.user['pk'].toString()};

        var res = await http.post(url, headers: headers, body: body);
        // print(token);
        // print(res.statusCode);
        // print(res.body);
        if (res.statusCode == 201) {
          final result = json.decode(res.body);
          setState(() {
            isFollowed = result.isNotEmpty ? result[0] : {};
          });
        }
        // if (res.statusCode == 200) return res.body;
        return null;
      } on Exception {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userImage = AppDefaults.userImage(widget.user['user_document']);
    var userAddress = AppDefaults.userAddress(widget.user['user_addresses']);
    var sellerAddress =
        AppDefaults.sellerAddress(widget.user['seller_addresses']);

    var selfPk = account.isNotEmpty ? account['user']['pk'] : 0;

    // print(userImage);
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
                                  // Text(isFollowed.toString()),
                                  Text(
                                    '${widget.user['first_name']} ${widget.user['last_name']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                      height: AppDefaults.margin / 2),
                                  Visibility(
                                    visible: widget.user['pk'] != selfPk
                                        ? true
                                        : false,
                                    maintainSize: true, //NEW
                                    maintainAnimation: true, //NEW
                                    maintainState: true, //NEW
                                    child: Container(
                                      width: 90.0,
                                      height: 25.0,
                                      padding: EdgeInsets.zero,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          follow();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppDefaults.radius),
                                          ),
                                          side: const BorderSide(
                                              width: 1, color: Colors.white),
                                        ),
                                        child: Text(
                                          isFollowed.isNotEmpty
                                              ? 'Following'
                                              : '+ Follow',
                                          style: const TextStyle(
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
                                        builder: (_) => FollowingList(
                                            userPk: widget.user['pk'],
                                            token: token ?? ''));
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
                                      builder: (_) => FollowerList(
                                        userPk: widget.user['pk'],
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
                            widget.user['seller'] != null
                                ? widget.user['seller']['mobile_number']
                                : '',
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
                            widget.user['about'] ?? '',
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
