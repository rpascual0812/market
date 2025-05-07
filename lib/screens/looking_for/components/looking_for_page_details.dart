import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:market/components/network_image.dart';
import 'package:market/components/sliders/product_slider.dart';
import 'package:market/screens/chat/bubble.dart';
import 'package:market/screens/orders/order_page.dart';
import 'package:market/screens/producer/producer_page/producer_page.dart';
import 'package:market/screens/product/components/cart_page.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

import '../../../constants/index.dart';
import 'package:http/http.dart' as http;
// import 'color_picker.dart';

class LookingForPageDetails extends StatefulWidget {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  const LookingForPageDetails({
    super.key,
    required this.product,
    required this.account,
  });

  final Map<String, dynamic> product;
  final Map<String, dynamic> account;

  @override
  State<LookingForPageDetails> createState() => _LookingForPageDetailsState();
}

class _LookingForPageDetailsState extends State<LookingForPageDetails> {
  final storage = const FlutterSecureStorage();
  String token = '';

  @override
  void initState() {
    super.initState();

    readStorage();
    // Timer(const Duration(seconds: 2), () => getMeasurements());
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all!;
    });
  }

  Future saveToCart(pk) async {
    final token = await storage.read(key: 'jwt');
    final user = AppDefaults.jwtDecode(token!);

    try {
      final url = Uri.parse('${dotenv.get('API')}/orders');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = {
        'product_pk': widget.product['pk'].toString(),
        'measurement_pk': widget.product['measurement']['pk'].toString(),
        'quantity': widget.product['quantity'].toString(),
        'price': widget.product['price_from'].toString(),
        'status': 'Added to Cart'
      };

      var res = await http.post(url, headers: headers, body: body);
      // print(res.statusCode);
      if (res.statusCode == 200) {
        // final result = json.decode(res.body);
        setState(() {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success, title: "Added to Barket!"));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CartPage();
              },
            ),
          );
        });
      }
      // if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      return null;
    }
  }

  Future saveOrder(pk) async {
    final token = await storage.read(key: 'jwt');
    final user = AppDefaults.jwtDecode(token!);

    try {
      final url = Uri.parse('${dotenv.get('API')}/orders');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = {
        'product_pk': widget.product['pk'].toString(),
        'measurement_pk': widget.product['measurement']['pk'].toString(),
        'quantity': widget.product['quantity'].toString(),
        'price': widget.product['price_from'].toString(),
        'status': 'Ordered',
      };

      var res = await http.post(url, headers: headers, body: body);
      if (res.statusCode == 200) {
        // final result = json.decode(res.body);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const OrderPage(
                  type: 'orders',
                  user: {},
                );
              },
            ),
          );
        });
      }
      // if (res.statusCode == 200) return res.body;
      return null;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future setInterest() async {
    try {
      final url = Uri.parse(
          '${dotenv.get('API')}/products/${widget.product['pk'].toString()}/interested');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var res = await http.post(url, headers: headers);

      if (res.statusCode == 200) {
        if (!mounted) return;

        final dataJson = jsonDecode(res.body);
        AppDefaults.toast(
            context, 'success', AppMessage.getSuccess('INTERESTED'));

        setState(() {
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
    // print('produc2t ${widget.product}');
    var userImage = '${dotenv.get('S3')}/images/user.png';
    for (var i = 0; i < widget.product['user_document'].length; i++) {
      // print(product['product_documents'][i]['document']['path']);
      if (widget.product['user_document'][i]['document']['path'] != null &&
          widget.product['user_document'][i]['type'] == 'profile_photo') {
        userImage = '${widget.product['user_document'][i]['document']['path']}';
      }
    }

    // dataJson = jsonDecode(res.body);
    var userAddress = {};
    if (widget.product['type'] == 'looking_for') {
      var defaultFound = false;
      for (var i = 0; i < widget.product['user_addresses'].length; i++) {
        if (widget.product['user_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = widget.product['user_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = widget.product['user_addresses'].length > 0
            ? widget.product['user_addresses'][0]
            : {};
      }
    } else {
      var defaultFound = false;
      for (var i = 0; i < widget.product['seller_addresses'].length; i++) {
        if (widget.product['seller_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = widget.product['seller_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = widget.product['seller_addresses'][0];
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDefaults.radius),
          topRight: Radius.circular(AppDefaults.radius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: NetworkImageWithLoader(userImage, true),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 200,
                            height: 20,
                            child: Text(
                              widget.product['user'] != null
                                  ? '${widget.product['user']['first_name']} ${widget.product['user']['last_name']}'
                                  : '',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 200,
                            height: 20,
                            child: Row(
                              children: [
                                const Icon(
                                  LookingForPageDetails.pin,
                                  size: 12,
                                ),
                                Visibility(
                                  visible:
                                      userAddress.isNotEmpty ? true : false,
                                  child: Text(
                                    '${userAddress['city']?['name'] ?? ''}, ${userAddress['province']?['name'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.defaultBlack,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                      visible: widget.account['user'] != null &&
                              widget.product['user_pk'] ==
                                  widget.account['user']['pk']
                          ? false
                          : true,
                      child: Container(
                        width: 35.0,
                        height: 30.0,
                        padding: EdgeInsets.zero,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Bubble(
                                      userPk:
                                          widget.product['user_pk'].toString(),
                                      token: token,
                                      callback: (status) {});
                                },
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.primary,
                            ),
                            padding: const EdgeInsets.all(5),
                          ),
                          child: const Icon(
                            LookingForPageDetails.chat,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (widget.product['user']['is_seller'])
                      Container(
                        width: 70.0,
                        height: 30.0,
                        padding: EdgeInsets.zero,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProducerPage(
                                      userPk: widget.product['user']['pk']);
                                },
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.primary,
                            ),
                            padding: const EdgeInsets.all(0),
                          ),
                          child: const Text(
                            'View Shop',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 5)
                  ],
                ),
              ],
            ),
          ),
          // const Spacer(),
          // const SizedBox(height: AppDefaults.margin * 2),

          Visibility(
            visible:
                (widget.product['user_pk'] == widget.account['user']?['pk'])
                    ? false
                    : true,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              margin: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    setInterest();
                  },
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 1,
                        color: widget.product['interested'] != null &&
                                widget.product['interested'].length > 0
                            ? Colors.grey
                            : AppColors.primary,
                      ),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      backgroundColor: widget.product['interested'] != null &&
                              widget.product['interested'].length > 0
                          ? Colors.grey
                          : AppColors.primary),
                  child: const Text(
                    'I\'m Interested',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDefaults.margin * 2),

          // Title And Pricing
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LOOKING FOR',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppDefaults.fontSize + 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDefaults.margin),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product['name'] ?? '',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // Row(
                    //   children: [
                    //     Container(
                    //       width: 80.0,
                    //       height: 30.0,
                    //       padding: EdgeInsets.zero,
                    //       child: OutlinedButton(
                    //         onPressed: () async {
                    //           ArtDialogResponse response = await ArtSweetAlert.show(
                    //             barrierDismissible: false,
                    //             context: context,
                    //             artDialogArgs: ArtDialogArgs(
                    //                 type: ArtSweetAlertType.success,
                    //                 denyButtonText: "Cancel",
                    //                 denyButtonColor: Colors.grey,
                    //                 title: "Are you sure you want to buy this?",
                    //                 confirmButtonText: "Continue",
                    //                 confirmButtonColor: AppColors.primary),
                    //           );

                    //           if (response.isTapConfirmButton) {
                    //             if (!mounted) return;
                    //             saveOrder(widget.product['pk']);
                    //           }

                    //           if (response.isTapDenyButton) {
                    //             return;
                    //           }
                    //         },
                    //         style: OutlinedButton.styleFrom(
                    //           side: const BorderSide(
                    //             width: 1,
                    //             color: AppColors.primary,
                    //           ),
                    //           padding: const EdgeInsets.all(5),
                    //         ),
                    //         child: const Text(
                    //           'Order Now',
                    //           style: TextStyle(
                    //             color: AppColors.primary,
                    //             fontSize: 13,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 5),
                    //     Container(
                    //       width: 90.0,
                    //       height: 30.0,
                    //       padding: EdgeInsets.zero,
                    //       child: OutlinedButton(
                    //         onPressed: () async {
                    //           saveToCart(widget.product['pk']);

                    //           // ArtDialogResponse response = await ArtSweetAlert.show(
                    //           //     barrierDismissible: false,
                    //           //     context: context,
                    //           //     artDialogArgs: ArtDialogArgs(
                    //           //       type: ArtSweetAlertType.success,
                    //           //       denyButtonText: "Ok",
                    //           //       denyButtonColor: Colors.grey,
                    //           //       title:
                    //           //           "This product has been added to your cart",
                    //           //       confirmButtonText: "Go to Cart",
                    //           //     ));

                    //           // if (response.isTapConfirmButton) {
                    //           //   print('confirmed');
                    //           //   ArtSweetAlert.show(
                    //           //       context: context,
                    //           //       artDialogArgs: ArtDialogArgs(
                    //           //           type: ArtSweetAlertType.success,
                    //           //           title: "Saved!"));
                    //           //   return;
                    //           // }

                    //           // if (response.isTapDenyButton) {
                    //           //   return;
                    //           // }
                    //         },
                    //         style: OutlinedButton.styleFrom(
                    //           backgroundColor: AppColors.primary,
                    //           side: const BorderSide(
                    //             width: 1,
                    //             color: AppColors.primary,
                    //           ),
                    //           padding: const EdgeInsets.all(5),
                    //         ),
                    //         child: const Text(
                    //           'Add to Basket',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 13,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 5)
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(left: 10, right: 10),
          //   child: Text(
          //     '${widget.product['country']['currency_symbol']}${double.parse(widget.product['price_from']).toStringAsFixed(2)}',
          //     style: const TextStyle(
          //       fontFamily: '',
          //       color: AppColors.primary,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20,
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, right: 10),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (context) => RatingsPage(product: widget.product),
          //         ),
          //       );
          //     },
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const Text(
          //           'View Ratings',
          //           style: TextStyle(
          //             color: Colors.grey,
          //             fontSize: 12,
          //           ),
          //         ),
          //         Row(
          //           children: [
          //             RatingBarIndicator(
          //               rating: widget.product['product_rating_total'] != null
          //                   ? double.parse(widget
          //                       .product['product_rating_total']
          //                       .toString())
          //                   : 5.00,
          //               itemBuilder: (context, index) => const Icon(
          //                 Icons.star,
          //                 color: Colors.amber,
          //               ),
          //               itemCount: 5,
          //               itemSize: 25.0,
          //             ),
          //             Text(
          //               '(${widget.product['product_rating_count'].toString()})',
          //               style: const TextStyle(
          //                 fontSize: 14,
          //                 color: Colors.grey,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Description
          const SizedBox(height: 20),

          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: AppColors.grey1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ProductSlider(
                  documents: widget.product['product_documents'] ?? []),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Product Details',
                  style: TextStyle(
                    fontSize: AppDefaults.fontSize + 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey2),
              ),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   child: Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: Row(
          //       children: const [
          //         SizedBox(
          //           width: 130,
          //           child: Text(
          //             'Product Posted',
          //             style: TextStyle(
          //               fontSize: 12,
          //             ),
          //           ),
          //         ),
          //         Text(
          //           'December 20, 2021',
          //           style: TextStyle(
          //             fontSize: 12,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: 130,
                      child: Text(
                        'Posted Date',
                        style: TextStyle(fontSize: AppDefaults.fontSize),
                      ),
                    ),
                  ),
                  Text(
                    widget.product['date_created'] != null
                        ? DateFormat('MMMM dd, yyyy').format(
                            DateTime.parse(widget.product['date_created']))
                        : '',
                    style: const TextStyle(
                      fontSize: AppDefaults.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey2),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: 130,
                      child: Text(
                        'Quantity',
                        style: TextStyle(fontSize: AppDefaults.fontSize),
                      ),
                    ),
                  ),
                  Text(
                    NumberFormat.decimalPattern()
                        .format(double.parse(widget.product['quantity'])),
                    style: const TextStyle(
                      fontSize: AppDefaults.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey2),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: 130,
                      child: Text(
                        'Price Range',
                        style: TextStyle(fontSize: AppDefaults.fontSize),
                      ),
                    ),
                  ),
                  Text(
                    '${widget.product['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.product['price_from']))} - ${widget.product['country']['currency_symbol']}${NumberFormat.decimalPattern().format(double.parse(widget.product['price_to']))}',
                    style: const TextStyle(
                      fontFamily: '',
                      fontSize: AppDefaults.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey2),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: 130,
                      child: Text(
                        'DESCRIPTION',
                        style: TextStyle(fontSize: AppDefaults.fontSize),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            widget.product['description'] ?? '',
                            style: const TextStyle(
                              fontSize: AppDefaults.fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
