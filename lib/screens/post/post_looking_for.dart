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

  var quantityMeasurements = [
    'Gram (g)',
    'Kilogram (kg)',
    'Pound (lb)',
    'Piece (pc)',
  ];

  final nameController = TextEditingController(text: '');
  final quantityController = TextEditingController(text: '');
  String quantityMeasurementController = 'Kilogram (kg)';
  RangeValues priceRangeValuesController = const RangeValues(100, 500);
  // final priceController = TextEditingController(text: '');
  String token = '';

  @override
  void initState() {
    super.initState();

    readStorage();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all!;
    });
  }

  Future submit() async {
    print('JWT: $token');
    final url = Uri.parse('${dotenv.get('API')}/products');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var res = await http.post(url, headers: headers, body: {
      "name": nameController.text,
      "quantity": quantityController.text,
      "measurement": quantityMeasurementController,
      'price_from': priceRangeValuesController.start.round().toString(),
      'price_to': priceRangeValuesController.end.round().toString()
    });
    print(res.statusCode);
    if (res.statusCode == 200) return res.body;
    return null;
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
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              var result = await submit();
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
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Ratings',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 10,
                            height: 20,
                            decoration: const BoxDecoration(
                              border: Border(
                                right:
                                    BorderSide(color: AppColors.defaultBlack),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Baguio Beans',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        onTap: () async {},
                        decoration: const InputDecoration(
                          // prefixIcon: IconWithBackground(iconData: IconlyBold.calendar),
                          // labelText: 'Birthday',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextField(
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      // labelText: 'First Name',
                                      border: OutlineInputBorder(),
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
                                  Container(
                                    padding: EdgeInsets.zero,
                                    margin: const EdgeInsets.all(0),
                                    child: DropdownButtonFormField<String>(
                                      isDense: true,
                                      value: quantityMeasurementController,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      // elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          quantityMeasurementController =
                                              value!;
                                        });
                                      },
                                      items: quantityMeasurements
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RangeSlider(
                                      values: priceRangeValuesController,
                                      max: 10000,
                                      divisions: 5,
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('+ Add Photo'),
                          ),
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
