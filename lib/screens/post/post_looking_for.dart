import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/network_image.dart';
import '../../../constants/index.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostLookingFor extends StatefulWidget {
  const PostLookingFor({Key? key}) : super(key: key);

  @override
  State<PostLookingFor> createState() => _PostLookingForState();
}

class _PostLookingForState extends State<PostLookingFor> {
  final storage = const FlutterSecureStorage();

  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  final nameController = TextEditingController(text: '');
  final quantityController = TextEditingController(text: '');

  List measurements = [];
  String quantityMeasurementController = '1';
  RangeValues priceRangeValuesController = const RangeValues(100, 500);
  // final priceController = TextEditingController(text: '');
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

      if (token != '') {
        getMeasurements();
      }
    });
  }

  Future getMeasurements() async {
    try {
      var body = json.decode(token);

      final url = Uri.parse('${dotenv.get('API')}/measurements');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${body['user']['access_token']}',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          measurements = result;
        });
      }
      // if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
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

  @override
  Widget build(BuildContext context) {
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
                                fontSize: AppDefaults.fontSize,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              var result = await submit();
                              if (!mounted) return;
                              if (result != null) {
                                Navigator.pop(context);
                              } else {
                                AppDefaults.displayDialog(
                                  context,
                                  "An Error Occurred",
                                  "An error occurred while saving product.",
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: AppDefaults.fontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                child: Row(
                  children: [
                    const SizedBox(
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: NetworkImageWithLoader(
                            'https://i.imgur.com/8G2bg5J.jpeg', true),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 150,
                            height: 20,
                            child: const Text(
                              'Kennet Egino',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 150,
                            height: 20,
                            child: Row(
                              children: const [
                                Icon(
                                  pin,
                                  size: 12,
                                ),
                                Text(
                                  'San Vicente, Manila',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.defaultBlack,
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
                          decoration: InputDecoration(
                            // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDefaults.radius),
                              borderSide: const BorderSide(width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDefaults.radius),
                              borderSide: const BorderSide(width: 1.0),
                            ),
                          ),
                          style: const TextStyle(fontSize: 14), // <-- SEE HERE
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
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      controller: quantityController,
                                      decoration: InputDecoration(
                                        // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDefaults.radius),
                                          borderSide:
                                              const BorderSide(width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDefaults.radius),
                                          borderSide:
                                              const BorderSide(width: 1.0),
                                        ),
                                      ),
                                      style: const TextStyle(
                                          fontSize: 14), // <-- SEE HERE
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
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDefaults.radius),
                                          borderSide:
                                              const BorderSide(width: 1.0),
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
                                    RangeSlider(
                                      activeColor: AppColors.primary,
                                      inactiveColor: AppColors.third,
                                      values: priceRangeValuesController,
                                      max: 10000,
                                      divisions: 20,
                                      labels: RangeLabels(
                                        priceRangeValuesController.start
                                            .round()
                                            .toString(),
                                        priceRangeValuesController.end
                                            .round()
                                            .toString(),
                                      ),
                                      onChanged: (RangeValues values) {
                                        setState(() {
                                          priceRangeValuesController = values;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      const SizedBox(height: AppDefaults.margin),
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
