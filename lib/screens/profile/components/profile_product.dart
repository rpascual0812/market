import 'package:flutter/material.dart';
import 'package:market/screens/orders/order_page.dart';
import 'package:market/screens/profile/components/profile_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../constants/index.dart';

class ProfileProduct extends StatefulWidget {
  const ProfileProduct({
    Key? key,
    required this.token,
    required this.user,
  }) : super(key: key);

  final String token;
  final Map<String, dynamic> user;

  static const IconData box =
      IconData(0xe806, fontFamily: 'Custom', fontPackage: null);
  static const IconData cart =
      IconData(0xe807, fontFamily: 'Custom', fontPackage: null);

  @override
  State<ProfileProduct> createState() => _ProfileProductState();
}

class _ProfileProductState extends State<ProfileProduct> {
  final storage = const FlutterSecureStorage();

  String producerPk = '';

  @override
  void initState() {
    super.initState();

    readStorage();
  }

  Future<void> readStorage() async {
    final pk = await storage.read(key: 'producer');

    setState(() {
      producerPk = pk!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ProfileCard(
            producerPk: producerPk,
            iconData: ProfileProduct.box,
            iconBackground: producerPk == '0'
                ? AppColors.grey1.withOpacity(0.5)
                : AppColors.primary.withOpacity(0.5),
            iconColor: producerPk == '0' ? Colors.black12 : AppColors.primary,
            statusName: 'My Products',
            status: '10+',
            onTap: () {
              if (producerPk == '0') {
                //dont do anything for now
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return OrderPage(type: 'products', user: widget.user);
                    },
                  ),
                );
              }
            },
          ),
          ProfileCard(
            producerPk: producerPk,
            iconData: ProfileProduct.cart,
            iconBackground: Colors.blue.withOpacity(0.1),
            iconColor: Colors.blue,
            statusName: 'My Orders',
            status: '5',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OrderPage(type: 'orders', user: widget.user);
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
