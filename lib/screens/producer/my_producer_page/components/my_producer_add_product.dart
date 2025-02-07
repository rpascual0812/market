import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:market/screens/producer/my_producer_page/my_producer_page.dart';
// import 'package:market/components/network_image.dart';

import '../../../../components/network_image.dart';
import '../../../../constants/index.dart';
// import 'package:market/models/ratings.dart';

class MyProducerAddProduct extends StatefulWidget {
  const MyProducerAddProduct({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  State<MyProducerAddProduct> createState() => _MyProducerAddProductState();
}

class _MyProducerAddProductState extends State<MyProducerAddProduct> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();
  String token = '';

  List measurements = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController measurementController =
      TextEditingController(text: '1');
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var categoryValue = '1';
  var categories = [];

  List documents = [];

  @override
  void initState() {
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();

    getCategories();
    readStorage();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all!;
      getMeasurements();
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

      return null;
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  Future pickFile(List<String> ext) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ext,
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        // print('NAME: ${file.name}');
        // print('SIZE: ${file.size}');
        // print('EXT: ${file.extension}');
        // print('PATH: ${file.path}');

        final imageTemp = File(file.path!);

        final document = await upload(
          'documents',
          imageTemp,
        );

        Map<String, dynamic> json = jsonDecode(document);
        // print('document $document');
        // print('JSON: $json');
        setState(() {
          documents.add(json['document']);
          // print(documents);
        });
      } else {
        // User canceled the picker
      }
    } on Exception {
      AppDefaults.toast(
          context, 'error', AppMessage.getError('ERROR_FILE_FAILED'));
    }
  }

  remove(String type, int index) {
    setState(() {
      documents.removeAt(index);
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
          'image',
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
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  Future save() async {
    if (_key.currentState!.validate()) {
      try {
        var documentPks = [];
        for (var document in documents) {
          documentPks.add(document['pk']);
        }

        var body = {
          'type': 'product',
          'name': productNameController.text,
          'price_from': priceController.text,
          'quantity': stockController.text,
          'date_available': dateController.text.toString(),
          'description': descriptionController.text,
          'measurement': measurementController.text,
          'category': categoryValue,
          'documents': documentPks.join(','),
        };

        final url = Uri.parse('${dotenv.get('API')}/products');
        final headers = {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        };

        var res = await http.post(url, headers: headers, body: body);

        if (res.statusCode == 200) {
          var result = json.decode(res.body);

          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "Success!",
                text: "Your product has been successfully added."),
          );

          if (!mounted) return;
          var jwt = AppDefaults.jwtDecode(token);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MyProducerPage(
                    accountPk: jwt['sub'].toString(), token: token);
              },
            ),
          );
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

  @override
  Widget build(BuildContext context) {
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
                              var account = await save();
                              if (account != null) {}
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
                      const Row(
                        children: [
                          Text(
                            'Upload Product',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDefaults.fontSize + 5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDefaults.margin / 4),
                    ],
                  ),
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
                            'Product Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin / 2),
                        SizedBox(
                          child: TextFormField(
                            controller: productNameController,
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
                              // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                              focusedBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              enabledBorder:
                                  AppDefaults.outlineInputBorderSuccess,
                              focusedErrorBorder:
                                  AppDefaults.outlineInputBorderError,
                              errorBorder: AppDefaults.outlineInputBorderError,
                            ),
                            style: AppDefaults.formTextStyle,
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Estimated Quantity',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: AppDefaults.margin / 2),
                                  SizedBox(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: stockController,
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
                                        // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                        focusedBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        enabledBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        focusedErrorBorder:
                                            AppDefaults.outlineInputBorderError,
                                        errorBorder:
                                            AppDefaults.outlineInputBorderError,
                                      ),
                                      style: AppDefaults.formTextStyle,
                                    ),
                                  ),
                                ],
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
                                        value: measurementController.text,
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
                                            measurementController.text = value!;
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
                                        'Price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: AppDefaults.margin / 2),
                                    SizedBox(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: priceController,
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
                                          // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                          focusedBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          enabledBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          focusedErrorBorder: AppDefaults
                                              .outlineInputBorderError,
                                          errorBorder: AppDefaults
                                              .outlineInputBorderError,
                                        ),
                                        style: AppDefaults.formTextStyle,
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
                                        'Available On',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: AppDefaults.margin / 2),
                                    SizedBox(
                                      // padding: EdgeInsets.zero,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: dateController,
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return '* required';
                                          }
                                          return null;
                                        },
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                                const Duration(days: 0)),
                                            lastDate: DateTime.now().add(
                                                const Duration(days: 3650)),
                                          );
                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            setState(() {
                                              dateController.text =
                                                  formattedDate; //set output date to TextField value.
                                            });
                                          } else {
                                            // print("Date is not selected");
                                          }
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: AppDefaults.edgeInset,
                                          prefixIconConstraints:
                                              const BoxConstraints(
                                                  minWidth: 0, minHeight: 0),
                                          // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                          focusedBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          enabledBorder: AppDefaults
                                              .outlineInputBorderSuccess,
                                          focusedErrorBorder: AppDefaults
                                              .outlineInputBorderError,
                                          errorBorder: AppDefaults
                                              .outlineInputBorderError,
                                        ),
                                        style: AppDefaults.formTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Product Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin / 2),
                        Container(
                          width: 370.0,
                          height: 120.0,
                          // color: AppColors.grey2,
                          padding: EdgeInsets.zero,
                          child: SizedBox(
                            child: TextFormField(
                              maxLines: 10,
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
                                // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                focusedBorder:
                                    AppDefaults.outlineInputBorderSuccess,
                                enabledBorder:
                                    AppDefaults.outlineInputBorderSuccess,
                                focusedErrorBorder:
                                    AppDefaults.outlineInputBorderError,
                                errorBorder:
                                    AppDefaults.outlineInputBorderError,
                              ),
                              style: AppDefaults.formTextStyle,
                            ),
                          ),
                        ),
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
                        const SizedBox(height: AppDefaults.margin),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Attach Product Photo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        Visibility(
                          visible: documents.isNotEmpty ? true : false,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: List.generate(
                                documents.length,
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
                                              "Do you want to remove ${documents[index]['original_name']}?",
                                          confirmButtonText: "Remove",
                                        ),
                                      );

                                      if (response.isTapConfirmButton) {
                                        remove('photos', index);
                                        return;
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 75,
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: NetworkImageWithLoader(
                                            '${dotenv.get('API')}/${documents[index]['path']}',
                                            false),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin / 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                pickFile(['jpg', 'png']);
                              },
                              child: const Text('+ Add Photo'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
