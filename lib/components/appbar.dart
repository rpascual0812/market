import 'package:flutter/material.dart';
import 'package:market/screens/notifications/notification_page.dart';

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
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Visibility(
              visible: showHide(),
              child: IconButton(
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
            const SizedBox(width: 10),
          ],
        )
      ],
    );
  }

  showHide() {
    switch (module) {
      case 'home':
        {
          return true;
        }
      case 'signin':
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
