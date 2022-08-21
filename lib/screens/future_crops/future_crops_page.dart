import 'package:flutter/material.dart';
import 'package:market/components/future_crops_page_tile.dart';

import 'package:market/models/order.dart';

class FutureCropsPage extends StatefulWidget {
  const FutureCropsPage({Key? key}) : super(key: key);

  @override
  State<FutureCropsPage> createState() => _FutureCropsPageState();
}

class _FutureCropsPageState extends State<FutureCropsPage> {
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
                        'No data found',
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
          FutureCropsPageTile(
            name: 'Juan Dela Cruz',
            profile_photo: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Almonds',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            location: 'Davao',
            product_photo: 'https://i.imgur.com/zdLsFZ0.jpeg',
            onTap: () {},
          ),
          FutureCropsPageTile(
            name: 'Juan Dela Cruz',
            profile_photo: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Banana Supplier',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            location: 'Davao',
            product_photo: 'https://i.imgur.com/R3Cpn1T.jpeg',
            onTap: () {},
          ),
          FutureCropsPageTile(
            name: 'Juan Dela Cruz',
            profile_photo: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Almonds',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            product_photo: 'https://i.imgur.com/zdLsFZ0.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
          FutureCropsPageTile(
            name: 'Juan Dela Cruz',
            profile_photo: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Banana Supplier',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            product_photo: 'https://i.imgur.com/R3Cpn1T.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
          FutureCropsPageTile(
            name: 'Juan Dela Cruz',
            profile_photo: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Almonds',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            product_photo: 'https://i.imgur.com/zdLsFZ0.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
          FutureCropsPageTile(
            name: 'Juan Dela Cruz',
            profile_photo: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Banana Supplier',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            product_photo: 'https://i.imgur.com/R3Cpn1T.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
        ],
      );
}
