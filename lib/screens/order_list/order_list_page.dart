// import 'dart:html';

import 'package:flutter/material.dart';

// import 'package:market/db/market_db.dart';
import 'package:market/models/order.dart';

import 'components/product_tile_cart.dart';

// import 'package:qr_flutter/qr_flutter.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);
  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late List<Order> orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshOrders();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();

    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Header
        AppBar(
          leading: const SizedBox(),
          title: const Text('Orders'),
        ),

        /// Use List View Here
        Expanded(
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : orders.isEmpty
                    ? const Text(
                        'No Orders found',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      )
                    : buildOrders(),
          ),
        ),
      ],
    );
  }

  Widget buildOrders() => ListView(
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          ProductTileCart(
            name: 'Henley Shirts',
            price: 250,
            coverImage: 'https://i.imgur.com/PFBRThN.png',
            quantity: 1,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
          ProductTileCart(
            name: 'Casual Shirts',
            price: 145,
            coverImage: 'https://i.imgur.com/fDwKPuo.png',
            quantity: 3,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
          ProductTileCart(
            name: 'Casual Nolin',
            price: 225,
            coverImage: 'https://i.imgur.com/1phVInw.png',
            quantity: 1,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
          ProductTileCart(
            name: 'Casual Nolin',
            price: 225,
            coverImage: 'https://i.imgur.com/y8oqJX3.png',
            quantity: 1,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
          ProductTileCart(
            name: 'Henley Shirts',
            price: 250,
            coverImage: 'https://i.imgur.com/PFBRThN.png',
            quantity: 1,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
          ProductTileCart(
            name: 'Casual Shirts',
            price: 145,
            coverImage: 'https://i.imgur.com/fDwKPuo.png',
            quantity: 3,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
          ProductTileCart(
            name: 'Casual Nolin',
            price: 225,
            coverImage: 'https://i.imgur.com/1phVInw.png',
            quantity: 1,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
          ProductTileCart(
            name: 'Casual Nolin',
            price: 225,
            coverImage: 'https://i.imgur.com/y8oqJX3.png',
            quantity: 1,
            increaseQuantity: () {},
            decreaseQuantity: () {},
          ),
        ],
      );
}
