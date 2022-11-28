import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/future_crops/future_crops_page.dart';
import 'package:market/screens/looking_for/looking_for_list.dart';
import 'package:http/http.dart' as http;

import '../../constants/index.dart';

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

  final storage = const FlutterSecureStorage();
  String token = '';
  Map<String, dynamic> account = {};

  @override
  void initState() {
    super.initState();
    readStorage();
    _tabController.index = widget.index;
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all ?? '';
      var pk = AppDefaults.jwtDecode(token);
      fetchUser(pk['sub']);
    });
  }

  Future fetchUser(int pk) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$pk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          account = json.decode(res.body);
          // print(account);
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
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
                children: [
                  Scaffold(
                    body: FutureCropsPage(token: token, account: account),
                  ),
                  Scaffold(
                    body: LookingForList(token: token, account: account),
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
