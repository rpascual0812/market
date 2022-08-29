import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/screens/orders/components/my_orders.dart';
import 'package:market/screens/orders/components/my_products.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fourth,
      appBar: Appbar(module: 'orders'),
      body: DefaultTabController(
        initialIndex: type == 'products' ? 0 : 1,
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, top: 5),
              width: 50,
              child: InkWell(
                onTap: (() => Navigator.of(context).pop()),
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
            const TabBar(
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'My Products',
                ),
                Tab(
                  text: 'My Orders',
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  MyProducts(),
                  MyOrders(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
