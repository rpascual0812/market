// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../constants/index.dart';

class FollowerListTile extends StatelessWidget {
  const FollowerListTile({
    super.key,
    required this.follower,
    this.onTap,
  });

  static const IconData chat =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  final Map<String, dynamic> follower;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (follower['createdBy'] != null) {
      userImage = AppDefaults.userImage(follower['createdBy']['user_document']);
    }

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 80,
      margin: const EdgeInsets.only(bottom: AppDefaults.margin / 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.margin,
          vertical: AppDefaults.margin,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                    maxRadius: 20,
                  ),
                  Positioned(
                    top: 10,
                    left: 50,
                    child: Row(
                      children: [
                        Text(
                          '${follower['createdBy']['first_name']} ${follower['createdBy']['last_name']}',
                          style: const TextStyle(
                            fontSize: AppDefaults.fontSize + 2,
                            color: AppColors.defaultBlack,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: Row(
                      children: [
                        Container(
                          width: 90.0,
                          height: 25.0,
                          padding: EdgeInsets.zero,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDefaults.radius),
                              ),
                              side: const BorderSide(
                                  width: 1, color: Colors.grey),
                            ),
                            child: Text(
                              follower['isAlsoFollowed'].isEmpty
                                  ? '+ Follow'
                                  : 'Following',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: AppDefaults.fontSize + 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
