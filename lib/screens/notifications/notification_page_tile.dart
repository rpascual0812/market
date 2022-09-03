// import 'dart:html';

import 'package:flutter/material.dart';

import '../../constants/index.dart';

class NotificationPageTile extends StatelessWidget {
  static const IconData chat =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const NotificationPageTile({
    Key? key,
    required this.title,
    required this.description,
    required this.read,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String description;
  final bool read;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.all(AppDefaults.padding),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Center(
              child: Stack(
                children: [
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.margin,
                            vertical: AppDefaults.margin,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.defaultBlack,
                                                  fontWeight: read
                                                      ? FontWeight.normal
                                                      : FontWeight.bold),
                                            ),
                                            Text(
                                              description,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.defaultBlack,
                                                  fontWeight: read
                                                      ? FontWeight.normal
                                                      : FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: -10,
                                          right: 0,
                                          child: Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'View',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: AppColors
                                                          .defaultBlack,
                                                      fontWeight: read
                                                          ? FontWeight.normal
                                                          : FontWeight.bold),
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
                              const SizedBox(height: AppDefaults.margin / 10),
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
