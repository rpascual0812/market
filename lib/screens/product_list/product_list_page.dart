import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/screens/future_crops/future_crops_page.dart';
import 'package:market/screens/looking_for/looking_for_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(module: 'products'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: const [
            TabBar(
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'Looking for',
                ),
                Tab(
                  text: 'Future Crops',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Scaffold(
                    body: LookingForPage(),
                  ),
                  Scaffold(
                    body: FutureCropsPage(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
