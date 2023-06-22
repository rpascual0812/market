import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/screens/product/components/cart_page_tile.dart';

import '../../../components/appbar.dart';
import '../../../constants/index.dart';
import '../../product/product_page.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final storage = const FlutterSecureStorage();
  String? token = '';

  bool isLoading = false;
  List orders = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getStorage();
  }

  Future getStorage() async {
    token = await storage.read(key: 'jwt');
    fetch();
  }

  Future<void> fetch() async {
    final url = Uri.parse('${dotenv.get('API')}/orders/cart');
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    var res = await http.get(
      url,
      headers: headers,
    );
    // print(res.statusCode);
    if (res.statusCode == 200) {
      setState(() {
        orders = [];
        dataJson = jsonDecode(res.body);
        for (var i = 0; i < dataJson['data'].length; i++) {
          dataJson['data'][i]['selected'] = false;
          orders.add(dataJson['data'][i]);
        }
      });
    }
    return;
    // } on Exception catch (exception) {
    //   print('exception $exception');
    // } catch (error) {
    //   print('error $error');
    // }
  }

  Future<void> order() async {
    var selectedProducts = [];

    for (var i = 0; i < orders.length; i++) {
      if (orders[i]['selected']) {
        selectedProducts.add(orders[i]['pk']);
      }
    }

    if (selectedProducts.isEmpty) {
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.danger,
          title: "Oops...",
          text: "You have not selected any products.",
        ),
      );
    } else {
      ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          denyButtonText: "Not yet!",
          denyButtonColor: AppColors.danger,
          title: "Are you sure you want to order the selected products?",
          confirmButtonText: "Order Now!",
          confirmButtonColor: AppColors.primary,
        ),
      );

      if (response.isTapConfirmButton) {
        final url = Uri.parse('${dotenv.get('API')}/orders/update');
        final headers = {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        };
        var body = {
          'status': 'Ordered',
          'order_pks': selectedProducts.join(','),
        };

        var res = await http.post(url, headers: headers, body: body);
        // print(res.statusCode);
        if (res.statusCode == 200) {
          setState(() {
            fetch();
          });
        }
      }
    }

    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Appbar(),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5, top: 5),
                    width: 50,
                    child: InkWell(
                      onTap: (() => Navigator.of(context).pop()),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 80.0,
                    height: 30.0,
                    padding: EdgeInsets.zero,
                    child: Visibility(
                      visible: orders.isNotEmpty ? true : false,
                      child: OutlinedButton(
                        onPressed: () async {
                          order();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 1,
                            color: AppColors.primary,
                          ),
                          padding: const EdgeInsets.all(5),
                        ),
                        child: const Text(
                          'Order Now',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: orders.isNotEmpty ? true : false,
              child: ListView.builder(
                itemCount: orders.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 5),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CartPageTile(
                      order: orders[index],
                      onToggle: () {
                        orders[index]['selected'] = !orders[index]['selected'];
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              productPk: orders[index]['product']['pk'],
                            ),
                          ),
                        );
                      },
                      callback: (product) {
                        fetch();
                      });
                },
              ),
            ),
            Visibility(
                visible: orders.isEmpty ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(height: AppDefaults.margin * 2),
                    Text(
                      'Your basket is empty',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
