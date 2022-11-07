import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/screens/approot/app_root.dart';
import 'package:market/screens/notifications/notification_page.dart';
import 'package:market/screens/product/components/cart_page.dart';
import 'package:market/screens/search/search_page.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  const Appbar({Key? key, this.module = 'home'}) : super(key: key);

  final String module;

  @override
  State<Appbar> createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _AppbarState extends State<Appbar> {
  final storage = const FlutterSecureStorage();
  String? token = '';

  @override
  void initState() {
    super.initState();
    readStorage();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AppRoot(jwt: token ?? ''),
                ),
              );
            },
            child: Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AppRoot(jwt: ''),
                ),
              );
            },
            child: const Text(
              'Samdhana Community Market',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          )
        ],
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [
            Visibility(
              visible: showHide(),
              child: IconButton(
                padding: const EdgeInsets.only(left: 10),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SearchPage();
                      },
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(width: 0),
            Visibility(
              visible: showHide(),
              child: IconButton(
                padding: const EdgeInsets.only(left: 10),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.shopping_cart),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CartPage();
                      },
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: showHide(),
              child: IconButton(
                padding: const EdgeInsets.only(left: 10, right: 10),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.notifications),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const NotificationPage();
                      },
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(width: 10),
          ],
        )
      ],
    );
  }

  showHide() {
    switch (widget.module) {
      case 'signin':
        {
          return false;
        }
      default:
        {
          return true;
        }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
