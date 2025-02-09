// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/screens/chat/bubble.dart';

import '../../../constants/index.dart';

class MyLookingForInterestedTile extends StatelessWidget {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  const MyLookingForInterestedTile({
    super.key,
    required this.token,
    required this.interested,
    this.onTap,
  });

  final String token;
  final Map<String, dynamic> interested;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (interested['user'] != null) {
      userImage = AppDefaults.userImage(interested['user']['user_document']);
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
                          '${interested['user']['first_name']} ${interested['user']['last_name']}',
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
                          width: 35.0,
                          height: 30.0,
                          padding: EdgeInsets.zero,
                          child: OutlinedButton(
                            onPressed: token != ''
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          // print(widget.product['user_pk'].toString());
                                          return Bubble(
                                              userPk: interested['user_pk']
                                                  .toString(),
                                              token: token,
                                              callback: (status) {});
                                        },
                                      ),
                                    );
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 1, color: AppColors.primary),
                              padding: const EdgeInsets.all(5),
                            ),
                            child: const Icon(
                              chat,
                              color: AppColors.primary,
                              size: 20,
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
