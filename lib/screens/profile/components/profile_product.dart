import 'package:flutter/material.dart';
import 'package:market/screens/orders/order_page.dart';
import 'package:market/screens/profile/components/profile_card.dart';

import '../../../constants/index.dart';

class ProfileProduct extends StatelessWidget {
  const ProfileProduct({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> user;

  static const IconData box =
      IconData(0xe806, fontFamily: 'Custom', fontPackage: null);
  static const IconData cart =
      IconData(0xe807, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ProfileCard(
            iconData: box,
            iconBackground: AppColors.primary.withOpacity(0.1),
            iconColor: AppColors.primary,
            statusName: 'My Products',
            status: '10+',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OrderPage(type: 'products', user: user);
                  },
                ),
              );
            },
          ),
          ProfileCard(
            iconData: cart,
            iconBackground: Colors.blue.withOpacity(0.1),
            iconColor: Colors.blue,
            statusName: 'My Orders',
            status: '5',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OrderPage(type: 'orders', user: user);
                  },
                ),
              );
            },
          ),
          // ProfileCard(
          //   iconData: Icons.star,
          //   iconBackground: Colors.yellow.withOpacity(0.1),
          //   iconColor: Colors.yellow,
          //   statusName: 'Reviews',
          //   status: '4.5K',
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }
}
