import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';
import 'package:http/http.dart' as http;
import 'package:market/screens/producer/producer_profile/producer_rating_tile.dart';

class ProducerProfile extends StatefulWidget {
  const ProducerProfile({
    super.key,
    required this.token,
    required this.userPk,
  });

  final String token;
  final int userPk;

  @override
  State<ProducerProfile> createState() => _ProducerProfileState();
}

class _ProducerProfileState extends State<ProducerProfile> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future fetch() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/sellers/${widget.userPk}');
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
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var name = '${user['first_name']} ${user['last_name']}';
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (user['user_document'] != null) {
      for (var i = 0; i < user['user_document'].length; i++) {
        if (user['user_document'][i]['document']['path'] != null &&
            user['user_document'][i]['type'] == 'profile_photo') {
          userImage =
              '${dotenv.get('API')}/${user['user_document'][i]['document']['path']}';
        }
      }
    }

    var userAddress = {};
    if (user['user_addresses'] != null) {
      var defaultFound = false;
      for (var i = 0; i < user['user_addresses'].length; i++) {
        if (user['user_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = user['user_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = user['user_addresses'][0];
      }
    }

    var sellerAddress = {};
    if (user['seller_addresses'] != null) {
      var defaultFound = false;
      for (var i = 0; i < user['seller_addresses'].length; i++) {
        if (user['seller_addresses'][i]['default']) {
          defaultFound = true;
          sellerAddress = user['seller_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = user['seller_addresses'][0];
      }
    }

    var city = '';
    var province = '';
    if (sellerAddress.isNotEmpty) {
      if (sellerAddress['city'] != null) {
        city = sellerAddress['city']['name'];
      }
      if (sellerAddress['province'] != null) {
        province = sellerAddress['province']['name'];
      }
    } else {
      if (userAddress['city'] != null) {
        city = userAddress['city']['name'];
      }
      if (userAddress['province'] != null) {
        province = userAddress['province']['name'];
      }
    }

    var location = '$city $province';

    print(user);
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.grey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.4),
                            BlendMode.dstATop),
                        image: const NetworkImage(
                          'https://i.imgur.com/CwxDJj8.jpeg',
                        ),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(userImage),
                              radius: 90,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppDefaults.fontSize + 5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user['about'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppDefaults.fontSize,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  pin,
                                  size: AppDefaults.fontSize,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: AppDefaults.fontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            RatingBarIndicator(
                              rating: user['product_rating_total'] != null
                                  ? double.parse(
                                      user['product_rating_total'].toString())
                                  : 0.00,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 45.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: SizedBox(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         TextButton(
              //           onPressed: () => Navigator.pop(context),
              //           style: TextButton.styleFrom(
              //               padding: EdgeInsets.zero,
              //               minimumSize: const Size(50, 30),
              //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //               alignment: Alignment.centerLeft),
              //           child: const Text(
              //             'Back',
              //             style: TextStyle(
              //               color: Colors.grey,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                // color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListView.builder(
                  itemCount: user['user_ratings'] != null
                      ? user['user_ratings'].length
                      : 0,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // return Text('asdf');
                    return ProducerRatingTile(
                        rating: user['user_ratings'][index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
