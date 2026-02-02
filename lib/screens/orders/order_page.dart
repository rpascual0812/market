import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/screens/orders/components/my_looking_for.dart';
import 'package:market/screens/orders/components/my_orders.dart';
import 'package:market/screens/orders/components/sold_products.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.type, required this.user});

  final String type;
  final Map<String, dynamic> user;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fourth,
      appBar: const Appbar(module: 'orders'),
      body: DefaultTabController(
        initialIndex: widget.type == 'products' ? 0 : 1,
        length: 3,
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
            TabBar(
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
                Tab(
                  text: 'My Looking For',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                SoldProducts(user: widget.user),
                MyOrders(user: widget.user),
                MyLookingFor(user: widget.user),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
