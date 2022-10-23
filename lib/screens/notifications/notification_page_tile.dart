// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../constants/index.dart';

class NotificationPageTile extends StatelessWidget {
  static const IconData chat =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const NotificationPageTile({
    Key? key,
    required this.message,
    required this.read,
    this.onTap,
  }) : super(key: key);

  final String message;
  final bool read;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';

    return Material(
      color: AppColors.fourth,
      borderRadius: AppDefaults.borderRadius,
      child: SingleChildScrollView(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.all(AppDefaults.padding),
            // padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Center(
              child: Stack(
                children: [
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.3),
                          //     spreadRadius: 5,
                          //     blurRadius: 7,
                          //     offset: const Offset(
                          //         0, 0), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.margin,
                            vertical: AppDefaults.margin,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userImage),
                                maxRadius: 20,
                              ),
                              const VerticalDivider(),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message,
                                          style: TextStyle(
                                              fontSize:
                                                  AppDefaults.fontSize + 2,
                                              color: AppColors.defaultBlack,
                                              fontWeight: read
                                                  ? FontWeight.normal
                                                  : FontWeight.bold),
                                        ),
                                        const Text('1d'),
                                      ],
                                    ),
                                    // Positioned(
                                    //   top: -10,
                                    //   right: 0,
                                    //   child: Row(
                                    //     children: [
                                    //       TextButton(
                                    //         onPressed: () {},
                                    //         child: Text(
                                    //           'View',
                                    //           style: TextStyle(
                                    //               fontSize: 10,
                                    //               color: AppColors.defaultBlack,
                                    //               fontWeight: read
                                    //                   ? FontWeight.normal
                                    //                   : FontWeight.bold),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
