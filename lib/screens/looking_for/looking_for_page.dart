import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/looking_for/components/looking_for_page_details.dart';

import '../../constants/index.dart';
import 'package:http/http.dart' as http;

class LookingForPage extends StatefulWidget {
  const LookingForPage({
    super.key,
    required this.productPk,
  });

  final int productPk;

  @override
  State<LookingForPage> createState() => _LookingForPageState();
}

class _LookingForPageState extends State<LookingForPage> {
  final storage = const FlutterSecureStorage();
  String? token = '';
  Map<String, dynamic> account = {};

  Map<String, dynamic> product = <String, dynamic>{};
  @override
  void initState() {
    super.initState();
    readStorage();
    fetch();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all;
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

  Future fetch() async {
    try {
      var res = await Remote.get('products/${widget.productPk}', {});
      if (res.statusCode == 200) {
        setState(() {
          var productJson = jsonDecode(res.body);
          product = productJson['data'];
        });
      }
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var accountPk = '';
    if (product['user'] != null && product['user']['account'] != null) {
      accountPk = product['user']['account']['pk'].toString();
    }

    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 0),
              //   child: ProductSlider(
              //       documents: product['product_documents'] ?? []),
              // ),
              Visibility(
                visible: product['name'] != null ? true : false,
                child:
                    LookingForPageDetails(product: product, account: account),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
