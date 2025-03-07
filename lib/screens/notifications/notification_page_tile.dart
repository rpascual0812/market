// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:time_elapsed/time_elapsed.dart';

import '../../constants/index.dart';

class NotificationPageTile extends StatelessWidget {
  static const IconData chat =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const NotificationPageTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  final Map<String, dynamic> notification;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('S3')}/images/user.png';
    var date = TimeElapsed.fromDateStr(notification['date_created']);

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
                                          notification['details'],
                                          style: TextStyle(
                                              fontSize:
                                                  AppDefaults.fontSize + 2,
                                              color: AppColors.defaultBlack,
                                              fontWeight: notification['read']
                                                  ? FontWeight.normal
                                                  : FontWeight.bold),
                                        ),
                                        Text(date == 'Now'
                                            ? 'Just $date'
                                            : '$date ago'),
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
