// import 'dart:html';

import 'package:flutter/material.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class FollowerListTile extends StatelessWidget {
  static const IconData chat =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const FollowerListTile({
    Key? key,
    required this.pk,
    required this.first_name,
    required this.last_name,
    required this.image,
    this.onTap,
  }) : super(key: key);

  final int pk;
  final String first_name;
  final String last_name;
  final String image;
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
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(image),
                                          maxRadius: 20,
                                        ),
                                        Positioned(
                                          top: 15,
                                          left: 50,
                                          child: Row(
                                            children: [
                                              Text(
                                                '$first_name $last_name',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.defaultBlack,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: -5,
                                          right: 0,
                                          child: Row(
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {},
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                  side: const BorderSide(
                                                      width: 2,
                                                      color: Colors.grey),
                                                ),
                                                child: const Text(
                                                  'View',
                                                  style: TextStyle(
                                                    color: Colors.grey,
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
