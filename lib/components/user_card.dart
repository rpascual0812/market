import 'package:flutter/material.dart';

import '../constants/index.dart';
import 'network_image.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.userImage,
    required this.firstName,
    required this.lastName,
    required this.address,
  });

  final String userImage;
  final String firstName;
  final String lastName;
  final String address;

  @override
  Widget build(BuildContext context) {
    const IconData pin =
        IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

    return Row(
      children: [
        SizedBox(
          height: 45,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: NetworkImageWithLoader(userImage, true),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                alignment: Alignment.centerLeft,
                width: 300,
                height: 20,
                child: Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: AppDefaults.fontSize,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                alignment: Alignment.centerLeft,
                width: 300,
                height: 20,
                child: Row(
                  children: [
                    const Icon(
                      pin,
                      size: 12,
                      color: Colors.black54,
                    ),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: AppDefaults.fontSize - 1,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
