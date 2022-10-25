import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/back_submit.dart';
import 'package:market/components/user_card.dart';
import '../../../constants/index.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:range_slider_dialog/range_slider_dialog.dart';

class PostLookingFor extends StatefulWidget {
  const PostLookingFor({Key? key}) : super(key: key);

  @override
  State<PostLookingFor> createState() => _PostLookingForState();
}

class _PostLookingForState extends State<PostLookingFor> {
  final storage = const FlutterSecureStorage();

  final nameController = TextEditingController(text: '');
  final quantityController = TextEditingController(text: '');
  var priceRangeController = TextEditingController(text: '');

  Map<String, dynamic> account = {};
  List measurements = [];
  String quantityMeasurementController = '1';
  // RangeValues priceRangeValuesController = const RangeValues(100, 500);
  // final priceController = TextEditingController(text: '');
  String token = '';

  final double _min = 1000;
  final double _max = 10000;
  final double _interval = 1500;
  SfRangeValues priceRangeValuesController =
      const SfRangeValues(1000.0, 5000.0);

  final minPrice = 0;
  final maxPrice = 10000;
  RangeValues rangeValues = const RangeValues(100, 1000);

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

      if (token != '') {
        getMeasurements();
        fetchUser();
      }
    });
  }

  Future getMeasurements() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/measurements');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

      var res = await http.get(
        url,
        headers: headers,
      );

      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          measurements = result;
        });
      }
      if (res.statusCode == 200) return res.body;

      // var body = json.decode(token);
      // final url = Uri.parse('${dotenv.get('API')}/measurements');
      // final headers = {
      //   'Accept': 'application/json',
      //   'Authorization': 'Bearer ${body['user']['access_token']}',
      // };

      // var res = await http.get(url, headers: headers);

      return null;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future fetchUser() async {
    var user = AppDefaults.jwtDecode(token);

    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/${user['sub']}');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          var userJson = jsonDecode(res.body);
          account = userJson;
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
        await storage.deleteAll();
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  Future submit() async {
    try {
      var body = json.decode(token);

      final url = Uri.parse('${dotenv.get('API')}/products');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${body['user']['access_token']}',
      };

      var res = await http.post(url, headers: headers, body: {
        "type": "looking_for",
        "name": nameController.text,
        "quantity": quantityController.text,
        "measurement": quantityMeasurementController,
        'price_from': priceRangeValuesController.start.round().toString(),
        'price_to': priceRangeValuesController.end.round().toString(),
        'currency': 'php'
      });

      if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      return null;
    }
  }

  Future clear() async {
    setState(() {
      nameController.text = '';
      quantityController.text = '';
      quantityMeasurementController = '1';
      priceRangeValuesController = const SfRangeValues(1000.0, 1500.0);
      // priceRangeValuesController = const RangeValues(100, 500);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (account['user'] != null) {
      userImage = AppDefaults.userImage(account['user']['user_document']);
    }

    var userAddress = {};
    if (account['user']['user_addresses'] != null) {
      for (var i = 0; i < account['user']['user_addresses'].length; i++) {
        if (account['user']['user_addresses'][i]['default']) {
          userAddress = account['user']['user_addresses'][i];
        }
      }
    }

    return Scaffold(
      appBar: Appbar(),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.grey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackSubmit(submit: () async {
                        var result = await submit();
                        if (!mounted) return;
                        if (result != null) {
                          AppDefaults.toast(context, 'success',
                              AppMessage.getSuccess('PRODUCT_LOOKING_SAVED'));
                          clear();
                          // Navigator.pop(context);
                        } else {
                          AppDefaults.displayDialog(
                            context,
                            "An Error Occurred",
                            "An error occurred while saving product.",
                          );
                        }
                      }, back: () {
                        Navigator.pop(context);
                      }),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     TextButton(
                      //       onPressed: () => Navigator.pop(context),
                      //       style: TextButton.styleFrom(
                      //           padding: EdgeInsets.zero,
                      //           minimumSize: const Size(50, 30),
                      //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //           alignment: Alignment.centerLeft),
                      //       child: const Text(
                      //         'Back',
                      //         style: TextStyle(
                      //           color: Colors.black54,
                      //           fontSize: AppDefaults.fontSize + 1,
                      //         ),
                      //       ),
                      //     ),
                      //     TextButton(
                      //       onPressed: () async {
                      //         var result = await submit();
                      //         if (!mounted) return;
                      //         if (result != null) {
                      //           AppDefaults.toastSuccess(
                      //               context,
                      //               AppMessage.getSuccess(
                      //                   'PRODUCT_LOOKING_SAVED'));
                      //           clear();
                      //           // Navigator.pop(context);
                      //         } else {
                      //           AppDefaults.displayDialog(
                      //             context,
                      //             "An Error Occurred",
                      //             "An error occurred while saving product.",
                      //           );
                      //         }
                      //       },
                      //       style: TextButton.styleFrom(
                      //           padding: EdgeInsets.zero,
                      //           minimumSize: const Size(50, 30),
                      //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //           alignment: Alignment.centerLeft),
                      //       child: const Text(
                      //         'Submit',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: AppDefaults.fontSize + 1,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Text(
                            'Create Looking For Post',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDefaults.fontSize + 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDefaults.margin / 2),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: UserCard(
                  userImage: userImage,
                  firstName: account['user']['first_name'],
                  lastName: account['user']['last_name'],
                  address: userAddress['city'] != null
                      ? '${userAddress['city']['name']}, ${userAddress['province']['name']}'
                      : '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SizedBox(height: AppDefaults.margin),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'What are you looking for?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDefaults.fontSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDefaults.margin / 2),
                      SizedBox(
                        height: AppDefaults.height,
                        // padding: EdgeInsets.zero,
                        child: TextFormField(
                          controller: nameController,
                          validator: validateName,
                          decoration: InputDecoration(
                            // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDefaults.radius),
                              borderSide: const BorderSide(
                                  width: 1.0, color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDefaults.radius),
                              borderSide: const BorderSide(
                                  width: 1.0, color: Colors.grey),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: AppDefaults.fontSize), // <-- SEE HERE
                        ),
                      ),
                      const SizedBox(height: AppDefaults.margin),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Quantity',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppDefaults.fontSize,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: AppDefaults.margin / 2),
                                  SizedBox(
                                    height: AppDefaults.height,
                                    // padding: EdgeInsets.zero,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: quantityController,
                                      decoration: InputDecoration(
                                        // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDefaults.radius),
                                          borderSide: const BorderSide(
                                              width: 1.0, color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDefaults.radius),
                                          borderSide: const BorderSide(
                                              width: 1.0, color: Colors.grey),
                                        ),
                                      ),
                                      style: const TextStyle(
                                          fontSize: AppDefaults
                                              .fontSize), // <-- SEE HERE
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: AppDefaults.margin / 2),
                                  SizedBox(
                                    height: AppDefaults.height,
                                    // padding: EdgeInsets.zero,
                                    child: DropdownButtonFormField<String>(
                                      isDense: true,
                                      value: quantityMeasurementController,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      // elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDefaults.radius),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDefaults.radius),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          quantityMeasurementController =
                                              value!;
                                        });
                                      },
                                      items: measurements
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value['pk'].toString(),
                                          child: Text(
                                              '${value['name']} (${value['symbol']})'),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDefaults.margin),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Price Range',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppDefaults.fontSize,
                                        ),
                                      ),
                                    ),
                                    // SfRangeSlider(
                                    //   dragMode: SliderDragMode.both,
                                    //   min: _min,
                                    //   max: _max,
                                    //   values: priceRangeValuesController,
                                    //   interval: _interval,
                                    //   showTicks: true,
                                    //   showLabels: true,
                                    //   enableTooltip: true,
                                    //   onChanged: (SfRangeValues value) {
                                    //     setState(() {
                                    //       print(value.start);
                                    //       print(value.end);
                                    //       priceRangeValuesController = value;
                                    //     });
                                    //   },
                                    // ),
                                    const SizedBox(height: AppDefaults.margin),
                                    SizedBox(
                                      height: AppDefaults.height,
                                      // padding: EdgeInsets.zero,
                                      child: TextFormField(
                                        controller: priceRangeController,
                                        showCursor: true,
                                        readOnly: true,
                                        onTap: () async {
                                          await RangeSliderDialog.display<int>(
                                            context,
                                            minValue: minPrice,
                                            maxValue: maxPrice,
                                            acceptButtonText: 'Save',
                                            cancelButtonText: 'Cancel',
                                            headerText: 'Select Price Range',
                                            selectedRangeValues: rangeValues,
                                            onApplyButtonClick: (value) {
                                              print('SHOW PEOPLE DIALOG');
                                              print(value);

                                              setState(() {
                                                priceRangeController =
                                                    TextEditingController(
                                                        text:
                                                            '${value?.start.round().toString()} - ${value?.end.round().toString()}');
                                              });

                                              if (value != null) {
                                                rangeValues = RangeValues(
                                                    value.start, value.end);
                                              }

                                              // callback(value);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        decoration: InputDecoration(
                                          // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppDefaults.radius),
                                            borderSide: const BorderSide(
                                                width: 1.0, color: Colors.grey),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppDefaults.radius),
                                            borderSide: const BorderSide(
                                                width: 1.0, color: Colors.grey),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            fontSize: AppDefaults
                                                .fontSize), // <-- SEE HERE
                                      ),
                                    ),

                                    // RangeSlider(
                                    //   activeColor: AppColors.primary,
                                    //   inactiveColor: AppColors.third,
                                    //   values: priceRangeValuesController,
                                    //   max: 10000,
                                    //   divisions: 20,
                                    //   labels: RangeLabels(
                                    //     priceRangeValuesController.start
                                    //         .round()
                                    //         .toString(),
                                    //     priceRangeValuesController.end
                                    //         .round()
                                    //         .toString(),
                                    //   ),
                                    //   onChanged: (RangeValues values) {
                                    //     setState(() {
                                    //       priceRangeValuesController = values;
                                    //     });
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      const SizedBox(height: AppDefaults.margin * 2),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Attach Display Photo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDefaults.fontSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppDefaults.margin / 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: AppDefaults.height,
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: ElevatedButton(
                                onPressed: () async {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDefaults.radius),
                                  ),
                                ),
                                child: const Text('+ Add Photo'),
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   child: const Text('+ Add Photo'),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Password is required.';
  }

  return null;
}
