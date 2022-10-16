import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constants/index.dart';
// import 'package:market/models/ratings.dart';

class RateProductPage extends StatefulWidget {
  const RateProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Map<String, dynamic> product;

  @override
  State<RateProductPage> createState() => _RateProductPageState();
}

class _RateProductPageState extends State<RateProductPage> {
  final storage = const FlutterSecureStorage();
  String token = '';

  TextEditingController message = TextEditingController(text: '');
  TextEditingController rating = TextEditingController(text: '5.00');
  var ratingVal = 5.00;
  TextEditingController anonymous = TextEditingController(text: 'false');

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
      fetch();
    });
  }

  Future fetch() async {
    try {
      var tokenObj = json.decode(token);
      var params = {'product_pk': widget.product['pk'].toString()};

      final url = Uri.parse('${dotenv.get('API')}/products/rating')
          .replace(queryParameters: params);
      final headers = {
        HttpHeaders.authorizationHeader:
            'Bearer ${tokenObj['user']['access_token']}',
      };

      var res = await http.get(
        url,
        headers: headers,
      );

      var ratingJson = jsonDecode(res.body)['data'];

      setState(() {
        message.text = ratingJson['message'] ?? '';
        ratingVal = double.parse(ratingJson['rating']);
        rating.text = ratingJson['rating'];
        anonymous.text = 'true';
      });
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future submit() async {
    try {
      var tokenObj = json.decode(token);
      final url = Uri.parse('${dotenv.get('API')}/products/rating');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenObj['user']['access_token']}',
      };

      var body = {
        'message': message.text,
        'rating': rating.text,
        'anonymous': anonymous.text,
        'product_pk': widget.product['pk'].toString()
      };

      var res = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (res.statusCode == 200) {
        ArtDialogResponse response = await ArtSweetAlert.show(
          barrierDismissible: false,
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            showCancelBtn: false,
            title: "Success!",
            confirmButtonText: "Ok",
          ),
        );

        setState(() {
          message = TextEditingController(text: '');
          rating = TextEditingController(text: '5.00');
          anonymous = TextEditingController(text: 'false');

          if (response.isTapConfirmButton) {
            if (!mounted) return;
            Navigator.pop(context);
          }
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
      }

      return null;
    } on Exception {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = '${dotenv.get('API')}/assets/images/no-image.jpg';
    for (var i = 0; i < widget.product['product_documents'].length; i++) {
      if (widget.product['product_documents'][i]['document']['path'] != null &&
          widget.product['product_documents'][i]['default'] == true) {
        image =
            '${dotenv.get('API')}/${widget.product['product_documents'][i]['document']['path']}';
      }
    }

    return Scaffold(
      appBar: Appbar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              submit();
                            }),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Text(
                            'Rate Product',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 360.0,
                              height: 190.0,
                              padding: EdgeInsets.zero,
                              child: NetworkImageWithLoader(image, false),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              widget.product['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppDefaults.h7,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: const Text(
                                '',
                              ),
                            ),
                            // const SizedBox(height: AppDefaults.height / 3),
                            const SizedBox(height: 10),
                            RatingBar.builder(
                              initialRating: ratingVal,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              unratedColor: Colors.amber.withAlpha(50),
                              itemCount: 5,
                              itemSize: 50.0,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {
                                setState(() {
                                  rating = TextEditingController(
                                      text: value.toString());
                                });
                              },
                              updateOnDrag: true,
                            ),
                            const SizedBox(height: AppDefaults.height / 2),
                            Container(
                              width: 360.0,
                              height: 180.0,
                              // color: AppColors.grey2,
                              padding: EdgeInsets.zero,
                              child: TextField(
                                controller: message,
                                // onChanged: (value) => setState(() {
                                //   message = value;
                                // }),
                                maxLines: 10, //or null
                                decoration: const InputDecoration(
                                  fillColor: AppColors.grey2,
                                  hintText:
                                      "Share your experience and help others make better choices!",
                                  // border: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.teal),
                                  // ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.grey2, width: 0.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Add ${(50 - message.text.length).toString()} characters',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value:
                                      anonymous.text == 'true' ? true : false,
                                  onChanged: (bool? value) {
                                    anonymous.text = value.toString();
                                  },
                                ),
                                const Text(
                                  'Leave your review anonymously}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
