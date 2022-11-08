import 'dart:convert';

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
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  State<MyProducerPage> createState() => _MyProducerPageState();
}

class _MyProducerPageState extends State<MyProducerPage> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  TextEditingController messageController = TextEditingController();

  Map<String, dynamic> user = {};

  @override
  void initState() {
    var token = AppDefaults.jwtDecode(widget.token);

    super.initState();

    if (token != null) {
      fetchUser(token['sub']);
    }
  }

  Future fetchUser(int pk) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$pk');
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
      print('ERROR $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (user.isNotEmpty) {
      userImage = AppDefaults.userImage(user['user_document']);
    }

    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.grey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Visibility(
                visible: user.isNotEmpty ? true : false,
                child: MyProducerHeader(user: user),
              ),
              SizedBox(
                height: 1500,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: AppColors.primary,
                        indicatorColor: AppColors.primary,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
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
        ),
      ),
    );
  }
}
