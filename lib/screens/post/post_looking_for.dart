import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/back_submit.dart';
import 'package:market/components/user_card.dart';
import '../../../constants/index.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

// import 'package:range_slider_dialog/range_slider_dialog.dart';

import '../../components/network_image.dart';

import 'package:http_parser/http_parser.dart';

class PostLookingFor extends StatefulWidget {
  const PostLookingFor({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<PostLookingFor> createState() => _PostLookingForState();
}

class _PostLookingForState extends State<PostLookingFor> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  final nameController = TextEditingController(text: '');
  final descriptionController = TextEditingController(text: '');
  final quantityController = TextEditingController(text: '');
  var priceRangeController = TextEditingController(text: '');
  TextEditingController categoryController = TextEditingController();

  Map<String, dynamic> account = {};
  List measurements = [];
  String quantityMeasurementController = '1';
  // RangeValues priceRangeValuesController = const RangeValues(100, 500);
  // final priceController = TextEditingController(text: '');

  final double _min = 0.0;
  final double _max = 10000;
  final double _interval = 100;
  SfRangeValues priceRangeValuesController =
      const SfRangeValues(1000.0, 5000.0);

  double lowerPrice = 0.0;
  double upperPrice = 0.0;
  RangeValues rangeValues = const RangeValues(0, 10000);
  List photos = [];

  var categoryValue = '1';
  var categories = [];

  @override
  void initState() {
    lowerPrice = _min;
    upperPrice = _max;

    super.initState();

    getCategories();
    getMeasurements();
    fetchUser();
    // Timer(const Duration(seconds: 2), () => getMeasurements());
  }

  Future<void> getCategories() async {
    try {
      categories = [];
      var res = await Remote.get('categories', {});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          var dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            categories.add(dataJson['data'][i]);
          }

          categoryValue = categories[0]['pk'].toString();
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future getMeasurements() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/measurements');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
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
      // print('exception $exception');
    } catch (error) {
      // print('error $error');
    }
  }

  Future fetchUser() async {
    var user = AppDefaults.jwtDecode(widget.token);

    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/${user['sub']}');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
      };

      var res = await http.get(
        url,
        headers: headers,
      );

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
      return null;
    }
  }

  Future pickFile(String type, List<String> ext) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ext,
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        final imageTemp = File(file.path!);
        final document = await upload(
          'display',
          imageTemp,
        );

        Map<String, dynamic> json = jsonDecode(document);
        setState(() {
          photos.add(json);
        });
      } else {
        // User canceled the picker
      }
    } on Exception {
      AppDefaults.toast(
          context, 'error', AppMessage.getError('ERROR_FILE_FAILED'));
    }
  }

  remove(int index) {
    setState(() {
      photos.removeAt(index);
    });
  }

  Future upload(String type, File file) async {
    try {
      // List<int> imageBytes = await file.readAsBytes();
      // String base64Image = base64Encode(imageBytes);

      Uri url = Uri.parse('${dotenv.get('API')}/upload');
      http.MultipartRequest request = http.MultipartRequest('POST', url);

      request.fields['test'] = 'test';

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', 'jpg'),
        ),
      );

      var response = await request.send();
      return await response.stream.bytesToString();
      // var result = await response.stream.bytesToString();
      // print(result);
      // Map<String, dynamic> res = jsonDecode(result);

      // print(res['document']['pk']);
      // body['${type}_photo'] = result != ''
      //     ? '${dotenv.get('API')}/${res['document']['path'].toString()}'
      //     : '';
    } on Exception {
      AppDefaults.toast(
          context, 'error', AppMessage.getSuccess('ERROR_IMAGE_FAILED'));
      return null;
    }
  }

  Future submit() async {
    if (_key.currentState!.validate()) {
      try {
        final url = Uri.parse('${dotenv.get('API')}/products');
        final headers = {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
        };

        var photoPks = [];
        for (var photo in photos) {
          photoPks.add(photo['pk']);
        }

        var res = await http.post(url, headers: headers, body: {
          "type": "looking_for",
          "name": nameController.text,
          "description": descriptionController.text,
          "quantity": quantityController.text,
          "measurement": quantityMeasurementController,
          'price_from': priceRangeValuesController.start.round().toString(),
          'price_to': priceRangeValuesController.end.round().toString(),
          'category': categoryValue,
          'currency': 'php',
          'documents': photoPks.join(','),
          'status': 'Posted',
        });

        if (res.statusCode == 200) {
          ArtDialogResponse response = await ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                showCancelBtn: false,
                type: ArtSweetAlertType.success,
                title: "Success!",
                text: "You have successfully posted a product"),
          );

          if (response.isTapConfirmButton) {
            if (!mounted) return;
            Navigator.pop(context);
            return;
          }
        }
        return null;
      } on Exception catch (exception) {
        log('exception $exception');
      } catch (error) {
        log('error $error');
      }
    } else {
      AppDefaults.toast(context, 'error', AppMessage.getError('FORM_INVALID'));
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
    var userImage = '${dotenv.get('S3')}/images/user.png';
    if (account['user'] != null) {
      userImage = AppDefaults.userImage(account['user']['user_document']);
    }

    var userAddress = {};
    if (account['user'] != null && account['user']['user_addresses'] != null) {
      var defaultFound = false;
      for (var i = 0; i < account['user']['user_addresses'].length; i++) {
        if (account['user']['user_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = account['user']['user_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = account['user'].length > 0 &&
                account['user']['user_addresses'].length > 0
            ? account['user']['user_addresses'][0]
            : {};
      }
    }

    return Scaffold(
      appBar: const Appbar(),
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
                        await submit();
                      }, back: () {
                        Navigator.pop(context);
                      }),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
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
                  firstName: account['user'] != null
                      ? account['user']['first_name']
                      : '',
                  lastName: account['user'] != null
                      ? account['user']['last_name']
                      : '',
                  address: userAddress['city'] != null
                      ? '${userAddress['city']['name']}, ${userAddress['province']['name']}'
                      : '',
                ),
              ),
              Form(
                key: _key,
                child: Padding(
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
                          // padding: EdgeInsets.zero,
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '* required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: AppDefaults.edgeInset,
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              focusedBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              enabledBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              focusedErrorBorder:
                                  AppDefaults.outlineInputBorderError,
                              errorBorder: AppDefaults.outlineInputBorderError,
                            ),
                            style: const TextStyle(
                                fontSize: AppDefaults.fontSize), // <-- SEE HERE
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDefaults.fontSize,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin / 2),
                        SizedBox(
                          // padding: EdgeInsets.zero,
                          child: TextFormField(
                            maxLines: 5,
                            controller: descriptionController,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '* required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: AppDefaults.edgeInset,
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              focusedBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              enabledBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              focusedErrorBorder:
                                  AppDefaults.outlineInputBorderError,
                              errorBorder: AppDefaults.outlineInputBorderError,
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
                                      // padding: EdgeInsets.zero,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: quantityController,
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return '* required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: AppDefaults.edgeInset,
                                          prefixIconConstraints:
                                              const BoxConstraints(
                                                  minWidth: 0, minHeight: 0),
                                          focusedBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          enabledBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          focusedErrorBorder: AppDefaults
                                              .outlineInputBorderError,
                                          errorBorder: AppDefaults
                                              .outlineInputBorderError,
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
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        // elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return '* required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: AppDefaults.edgeInset,
                                          prefixIconConstraints:
                                              const BoxConstraints(
                                                  minWidth: 0, minHeight: 0),
                                          focusedBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          enabledBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          focusedErrorBorder: AppDefaults
                                              .outlineInputBorderError,
                                          errorBorder: AppDefaults
                                              .outlineInputBorderError,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
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
                                      // Container(
                                      //   margin: EdgeInsets.only(
                                      //       top: 20, left: 20, right: 20),
                                      //   alignment: Alignment.centerLeft,
                                      //   child: FlutterSlider(
                                      //     values: [lowerPrice, upperPrice],
                                      //     rangeSlider: true,
                                      //     tooltip: FlutterSliderTooltip(
                                      //       alwaysShowTooltip: true,
                                      //     ),
                                      //     max: _min,
                                      //     min: _max,
                                      //     step: FlutterSliderStep(step: 20),
                                      //     jump: true,
                                      //     onDragging: (handlerIndex, lowerValue,
                                      //         upperValue) {
                                      //       setState(() {
                                      //         lowerPrice = lowerValue;
                                      //         upperPrice = upperValue;

                                      //         rangeValues = RangeValues(
                                      //           lowerPrice.toDouble(),
                                      //           upperPrice.toDouble(),
                                      //         );
                                      //       });
                                      //     },
                                      //   ),
                                      // ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 50, left: 50, right: 50),
                                        alignment: Alignment.centerLeft,
                                        child: FlutterSlider(
                                          values: [lowerPrice, upperPrice],
                                          rangeSlider: true,
                                          max: _max,
                                          min: _min,
                                          step: FlutterSliderStep(
                                              step: _interval),
                                          visibleTouchArea: true,
                                          trackBar: FlutterSliderTrackBar(
                                            inactiveTrackBarHeight: 14,
                                            activeTrackBarHeight: 10,
                                            inactiveTrackBar: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.black12,
                                              border: Border.all(
                                                  width: 3, color: Colors.blue),
                                            ),
                                            activeTrackBar: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.blue
                                                    .withValues(alpha: 0.5)),
                                          ),
                                          onDragging: (handlerIndex, lowerValue,
                                              upperValue) {
                                            // _lowerValue = lowerValue;
                                            // _upperValue = upperValue;
                                            setState(() {
                                              lowerPrice = lowerValue;
                                              upperPrice = upperValue;

                                              rangeValues = RangeValues(
                                                lowerPrice.toDouble(),
                                                upperPrice.toDouble(),
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                          height: AppDefaults.margin),
                                      // SizedBox(
                                      //   // padding: EdgeInsets.zero,
                                      //   child: TextFormField(
                                      //     controller: priceRangeController,
                                      //     showCursor: true,
                                      //     readOnly: true,
                                      //     onTap: () async {
                                      //       // await RangeSliderDialog.display<
                                      //       //     int>(
                                      //       //   context,
                                      //       //   minValue: minPrice,
                                      //       //   maxValue: maxPrice,
                                      //       //   acceptButtonText: 'Save',
                                      //       //   cancelButtonText: 'Cancel',
                                      //       //   headerText: 'Select Price Range',
                                      //       //   selectedRangeValues: rangeValues,
                                      //       //   onApplyButtonClick: (value) {
                                      //       //     // print('SHOW PEOPLE DIALOG');
                                      //       //     // print(value);

                                      //       //     setState(() {
                                      //       //       priceRangeController =
                                      //       //           TextEditingController(
                                      //       //               text:
                                      //       //                   '${value?.start.round().toString()} - ${value?.end.round().toString()}');
                                      //       //     });

                                      //       //     if (value != null) {
                                      //       //       rangeValues = RangeValues(
                                      //       //           value.start, value.end);
                                      //       //     }

                                      //       //     // callback(value);
                                      //       //     Navigator.pop(context);
                                      //       //   },
                                      //       // );
                                      //     },
                                      //     validator: (value) {
                                      //       if (value != null &&
                                      //           value.isEmpty) {
                                      //         return '* required';
                                      //       }
                                      //       return null;
                                      //     },
                                      //     decoration: InputDecoration(
                                      //       isDense: true,
                                      //       contentPadding:
                                      //           AppDefaults.edgeInset,
                                      //       prefixIconConstraints:
                                      //           const BoxConstraints(
                                      //               minWidth: 0, minHeight: 0),
                                      //       focusedBorder: AppDefaults
                                      //           .outlineInputBorderSuccess,
                                      //       enabledBorder: AppDefaults
                                      //           .outlineInputBorderSuccess,
                                      //       focusedErrorBorder: AppDefaults
                                      //           .outlineInputBorderError,
                                      //       errorBorder: AppDefaults
                                      //           .outlineInputBorderError,
                                      //     ),
                                      //     style: const TextStyle(
                                      //         fontSize: AppDefaults
                                      //             .fontSize), // <-- SEE HERE
                                      //   ),
                                      // ),

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
                        const SizedBox(height: AppDefaults.margin),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Category',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin / 2),
                        SizedBox(
                          height: AppDefaults.height,
                          // padding: EdgeInsets.zero,
                          child: DropdownButtonFormField<String>(
                            isDense: true,
                            value: categoryValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '* required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: AppDefaults.edgeInset,
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              focusedBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              enabledBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              focusedErrorBorder:
                                  AppDefaults.outlineInputBorderError,
                              errorBorder: AppDefaults.outlineInputBorderError,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                categoryValue = value!;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value['pk'].toString(),
                                child: Text('${value['name']}'),
                              );
                            }).toList(),
                          ),
                        ),
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
                        const SizedBox(height: AppDefaults.margin / 4),
                        Visibility(
                          visible: photos.isNotEmpty ? true : false,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: photos.isNotEmpty
                                  ? List.generate(
                                      photos.length,
                                      (index) {
                                        return InkWell(
                                          onTap: () async {
                                            ArtDialogResponse response =
                                                await ArtSweetAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              artDialogArgs: ArtDialogArgs(
                                                showCancelBtn: true,
                                                title:
                                                    "Do you want to remove ${photos[index]?['original_name']}?",
                                                confirmButtonText: "Remove",
                                              ),
                                            );

                                            if (response.isTapConfirmButton) {
                                              remove(index);
                                              return;
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 5, bottom: 5),
                                            height: 75,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: NetworkImageWithLoader(
                                                  '${photos[index]?['path']}',
                                                  false),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : [],
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
                                  onPressed: () {
                                    pickFile('photos', ['jpg', 'png']);
                                  },
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
