import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/screens/future_crops/future_crops_page.dart';
import 'package:market/screens/looking_for/looking_for_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  final int index;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabController.index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(module: 'products'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(
                  text: 'Future Crops',
                ),
                Tab(
                  text: 'Looking for',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Scaffold(
                    body: FutureCropsPage(),
                  ),
                  Scaffold(
                    body: LookingForPage(),
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
