import 'package:flutter/material.dart';
import 'package:market/screens/notifications/notification_page.dart';
import 'package:market/screens/product/components/cart_page.dart';
import 'package:market/screens/search/search_page.dart';

class Appbar extends StatelessWidget with PreferredSizeWidget {
  Appbar({Key? key, this.module = 'home'}) : super(key: key);

  final String module;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Samdhana Community Market',
            style: TextStyle(fontSize: 15, color: Colors.white),
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
    switch (module) {
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
