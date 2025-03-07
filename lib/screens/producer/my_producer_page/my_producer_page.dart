import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/screens/producer/my_producer_page/components/my_producer_header.dart';
import 'package:market/screens/producer/my_producer_page/components/my_products_tab.dart';

import '../../../constants/app_defaults.dart';

import 'package:http/http.dart' as http;

class MyProducerPage extends StatefulWidget {
  const MyProducerPage({
    super.key,
    required this.token,
    required this.accountPk,
  });

  final String token;
  final String accountPk;

  @override
  State<MyProducerPage> createState() => _MyProducerPageState();
}

class _MyProducerPageState extends State<MyProducerPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  TextEditingController messageController = TextEditingController();

  Map<String, dynamic> user = {};

  @override
  void initState() {
    // var token = AppDefaults.jwtDecode(widget.token);

    super.initState();

    fetchUser(widget.accountPk);
  }

  Future fetchUser(String pk) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/sellers/$pk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          var account = json.decode(res.body);
          user = account['user'];
        });
      }
      return null;
    } on Exception catch (e) {
      log('ERROR $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('S3')}/images/user.png';
    if (user.isNotEmpty) {
      userImage = AppDefaults.userImage(user['user_document']);
    }

    return Scaffold(
      appBar: const Appbar(module: 'products'),
      body: Column(
        children: [
          Visibility(
            visible: user.isNotEmpty ? true : false,
            child: MyProducerHeader(user: user),
          ),
          Expanded(
            child: DefaultTabController(
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
                        text: 'Products',
                      ),
                      Tab(
                        text: 'Future Crops',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Visibility(
                          visible: user['pk'] != null ? true : false,
                          child: MyProductsTab(
                            type: 'product',
                            userPk: user['pk'].toString(),
                          ),
                        ),
                        Visibility(
                          visible: user['pk'] != null ? true : false,
                          child: Scaffold(
                            body: MyProductsTab(
                                type: 'future_crop',
                                userPk: user['pk'].toString()),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
