import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:market/screens/chat/bubble.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';
import 'package:http/http.dart' as http;

class LookingForListTile extends StatefulWidget {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const LookingForListTile({
    Key? key,
    required this.token,
    required this.account,
    required this.product,
    this.onTap,
  }) : super(key: key);

  final String token;
  final Map<String, dynamic> account;
  final Map<String, dynamic> product;
  final void Function()? onTap;

  @override
  State<LookingForListTile> createState() => _LookingForListTileState();
}

class _LookingForListTileState extends State<LookingForListTile> {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  Future setInterest() async {
    try {
      final url = Uri.parse(
          '${dotenv.get('API')}/products/${widget.product['pk'].toString()}/interested');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.post(url, headers: headers);

      if (res.statusCode == 200) {
        if (!mounted) return;

        final dataJson = jsonDecode(res.body);

        AppDefaults.toast(
            context, 'success', AppMessage.getSuccess('INTERESTED'));

        setState(() {
          // print(dataJson['data']['data']);
          widget.product['interested'] = dataJson['data']['data'];
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
    // print('product ${widget.product['pk']} ${widget.product['interested']}');
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    for (var i = 0; i < widget.product['user_document'].length; i++) {
      // print(product['product_documents'][i]['document']['path']);
      if (widget.product['user_document'][i]['document']['path'] != null &&
          widget.product['user_document'][i]['type'] == 'profile_photo') {
        userImage =
            '${dotenv.get('API')}/${widget.product['user_document'][i]['document']['path']}';
      }
    }

    DateTime date = DateTime.parse(widget.product['date_created'].toString());

    var userAddress = {};
    if (widget.product['user_addresses'].length > 0) {
      var defaultFound = false;
      for (var i = 0; i < widget.product['user_addresses'].length; i++) {
        if (widget.product['user_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = widget.product['user_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = widget.product['user_addresses'][0];
      }
    }

    var sellerAddress = {};
    if (widget.product['seller_addresses'].length > 0) {
      var defaultFound = false;
      for (var i = 0; i < widget.product['seller_addresses'].length; i++) {
        if (widget.product['seller_addresses'][i]['default']) {
          defaultFound = true;
          sellerAddress = widget.product['seller_addresses'][i];
        }
      }

      if (!defaultFound) {
        sellerAddress = widget.product['seller_addresses'][0];
      }
    }

    var location = '';
    if (sellerAddress.isNotEmpty) {
      var city = '';
      if (sellerAddress['city'] != null) {
        city = sellerAddress['city']['name'];
      }
      var province = '';
      if (sellerAddress['province'] != null) {
        province = sellerAddress['province']['name'];
      }
      location = '$city, $province';
    } else {
      var city = '';
      if (userAddress['city'] != null) {
        city = userAddress['city']['name'];
      }
      var province = '';
      if (userAddress['province'] != null) {
        province = userAddress['province']['name'];
      }
      location = '$city, $province';
    }

    return GestureDetector(
      // no onTap event for now
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Material(
          // color: Colors.white,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
            borderRadius: AppDefaults.borderRadius,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.all(AppDefaults.padding),
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDefaults.margin,
                              vertical: AppDefaults.margin,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: NetworkImageWithLoader(
                                                  userImage, true),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            left: 55,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 200,
                                                    height: 20,
                                                    child: Text(
                                                      '${widget.product['user']['first_name']} ${widget.product['user']['last_name']}',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: AppDefaults
                                                                .fontSize +
                                                            2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 200,
                                                    height: 12,
                                                    child: Text(
                                                      DateFormat.yMMMd()
                                                          .format(date),
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: AppDefaults
                                                                  .fontSize -
                                                              2),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 200,
                                                    height: 15,
                                                    child: Row(
                                                      children: [
                                                        const Icon(pin,
                                                            size: AppDefaults
                                                                    .fontSize -
                                                                2,
                                                            color: Colors.grey),
                                                        Text(
                                                          location,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: AppDefaults
                                                                    .fontSize -
                                                                2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                (widget.product['user_pk'] ==
                                                        widget.account['user']
                                                            ['pk'])
                                                    ? false
                                                    : true,
                                            child: Positioned(
                                              right: 35,
                                              child: Container(
                                                width: 100.0,
                                                height: 30.0,
                                                padding: EdgeInsets.zero,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    setInterest();
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                          side: BorderSide(
                                                            width: 1,
                                                            color: widget.product[
                                                                            'interested'] !=
                                                                        null &&
                                                                    widget
                                                                            .product[
                                                                                'interested']
                                                                            .length >
                                                                        0
                                                                ? Colors.grey
                                                                : AppColors
                                                                    .primary,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          backgroundColor: widget
                                                                              .product[
                                                                          'interested'] !=
                                                                      null &&
                                                                  widget
                                                                          .product[
                                                                              'interested']
                                                                          .length >
                                                                      0
                                                              ? Colors.grey
                                                              : AppColors
                                                                  .primary),
                                                  child: Text(
                                                    widget.product['interested'] !=
                                                                null &&
                                                            widget
                                                                    .product[
                                                                        'interested']
                                                                    .length >
                                                                0
                                                        ? 'Interested'
                                                        : 'I\'m Interested',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget
                                                        .product['user_pk'] ==
                                                    widget.account['user']['pk']
                                                ? false
                                                : true,
                                            child: Positioned(
                                              right: 0,
                                              child: Container(
                                                width: 30.0,
                                                height: 30.0,
                                                padding: EdgeInsets.zero,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return Bubble(
                                                              token:
                                                                  widget.token,
                                                              userPk: widget
                                                                  .product[
                                                                      'user_pk']
                                                                  .toString(),
                                                              callback:
                                                                  (status) {});
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      width: 1,
                                                      color: AppColors.primary,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                  ),
                                                  child: const Icon(
                                                    chat,
                                                    color: AppColors.primary,
                                                    size: AppDefaults.fontSize +
                                                        10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.product['name'],
                                    style: const TextStyle(
                                      fontSize: AppDefaults.fontSize * 1.8,
                                      color: AppColors.defaultBlack,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Quantity: ${widget.product['quantity']} ${widget.product['measurement']['symbol']}',
                                    style: const TextStyle(
                                      fontSize: AppDefaults.fontSize,
                                      color: AppColors.defaultBlack,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Price range: ${widget.product['country']['currency_symbol']}${widget.product['price_from']} - ${widget.product['country']['currency_symbol']}${widget.product['price_to']} per ${widget.product['measurement']['name']}',
                                    style: const TextStyle(
                                      fontFamily: '',
                                      fontSize: AppDefaults.fontSize,
                                      color: AppColors.defaultBlack,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.product['description'],
                                    style: const TextStyle(
                                      fontFamily: '',
                                      fontSize: AppDefaults.fontSize,
                                      color: AppColors.defaultBlack,
                                    ),
                                  ),
                                ),
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     widget.product['description'],
                                //     style: const TextStyle(
                                //       fontSize: 9,
                                //       color: AppColors.defaultBlack,
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(height: AppDefaults.margin / 10),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    /// This will show only when hasFavourite parameter is true
                    // if (hasFavourite)
                    //   Positioned(
                    //     top: 8,
                    //     right: 8,
                    //     child: Container(
                    //       padding: const EdgeInsets.all(8.0),
                    //       decoration: const BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.white,
                    //       ),
                    //       child: Icon(
                    //         isFavourite ? IconlyBold.heart : IconlyLight.heart,
                    //         color: Colors.red,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
