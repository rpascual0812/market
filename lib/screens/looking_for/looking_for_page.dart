import 'package:flutter/material.dart';
import 'package:market/components/product_list_page_tile.dart';

import 'package:market/models/order.dart';

class LookingForPage extends StatefulWidget {
  const LookingForPage({Key? key}) : super(key: key);

  @override
  State<LookingForPage> createState() => _LookingForPageState();
}

class _LookingForPageState extends State<LookingForPage> {
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
        /// Use List View Here
        Expanded(
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : !orders.isEmpty
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
          ProductListPageTile(
            name: 'Juan Dela Cruz',
            imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Looking for Almonds',
            quantity: '103 kg',
            description: 'Lorem ipsum dolor sit amet',
            location: 'Davao',
            onTap: () {},
          ),
          ProductListPageTile(
            name: 'Juan Dela Cruz',
            imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Looking for Banana Supplier',
            quantity: '103 kg',
            description: 'Lorem ipsum dolor sit amet',
            location: 'Davao',
            onTap: () {},
          ),
          ProductListPageTile(
            name: 'Juan Dela Cruz',
            imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Looking for Almonds',
            quantity: '103 kg',
            description: 'Lorem ipsum dolor sit amet',
            location: 'Davao',
            onTap: () {},
          ),
          ProductListPageTile(
            name: 'Juan Dela Cruz',
            imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Looking for Banana Supplier',
            quantity: '103 kg',
            description: 'Lorem ipsum dolor sit amet',
            location: 'Davao',
            onTap: () {},
          ),
          ProductListPageTile(
            name: 'Juan Dela Cruz',
            imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Looking for Almonds',
            quantity: '103 kg',
            description: 'Lorem ipsum dolor sit amet',
            location: 'Davao',
            onTap: () {},
          ),
          ProductListPageTile(
            name: 'Juan Dela Cruz',
            imageLink: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Looking for Banana Supplier',
            quantity: '103 kg',
            description: 'Lorem ipsum dolor sit amet',
            location: 'Davao',
            onTap: () {},
          ),
        ],
      );
}
