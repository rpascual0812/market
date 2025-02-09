import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/components/appbar.dart';

import '../../../components/network_image.dart';
import '../../../constants/index.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../my_producer_page/my_producer_page.dart';

class ProducerRegister extends StatefulWidget {
  const ProducerRegister({super.key});

  @override
  State<ProducerRegister> createState() => _ProducerRegisterState();
}

class _ProducerRegisterState extends State<ProducerRegister> {
  final storage = const FlutterSecureStorage();
  String token = '';

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  List documents = [];
  List photos = [];

  // List of items in our dropdown menu
  var provinces = [];
  var cities = [];
  var areas = [];

  String provinceValue = '0';
  String cityValue = '0';
  String areaValue = '0';

  @override
  void initState() {
    super.initState();

    readStorage();
    getProvinces();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all!;
    });
  }

  Future getProvinces() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/provinces');
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          provinces = result['data'];

          cities = [];
          areas = [];

          provinces.insert(0, {'province_code': 0, 'name': 'Select'});
          cityValue = '0';
          areaValue = '0';
          // cities.add({'city_code': 0, 'name': 'Select'});
          // areas.add({'pk': 0, 'name': 'Select'});
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

  Future getCities() async {
    try {
      cities = [];
      final params = {'province_code': provinceValue};
      final url = Uri.parse('${dotenv.get('API')}/cities')
          .replace(queryParameters: params);
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          cities = result['data'];
          cities.insert(0, {'city_code': 0, 'name': 'Select'});
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

  Future getAreas() async {
    try {
      areas = [];
      final params = {'city_code': cityValue};
      final url = Uri.parse('${dotenv.get('API')}/areas')
          .replace(queryParameters: params);
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          areas = result['data'];
          areas.insert(0, {'pk': 0, 'name': 'Select'});
          // print(areas);
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

  Future pickFile(String type, List<String> ext) async {
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
          type == 'documents' ? 'documents' : 'display',
          imageTemp,
        );

        Map<String, dynamic> json = jsonDecode(document);
        // print('document $document');
        // print('JSON: $json');
        setState(() {
          if (type == 'documents') {
            documents.add(json['document']);
          } else {
            photos.add(json['document']);
          }
          // print(documents);
        });
      } else {
        // User canceled the picker
      }
    } on Exception {
      if (!context.mounted) return;
      AppDefaults.toast(
          context, 'error', AppMessage.getError('ERROR_FILE_FAILED'));
    }
  }

  remove(String type, int index) {
    setState(() {
      if (type == 'documents') {
        documents.removeAt(index);
      } else if (type == 'photos') {
        photos.removeAt(index);
      }
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
      if (!context.mounted) return;
      AppDefaults.toast(
          context, 'error', AppMessage.getSuccess('ERROR_IMAGE_FAILED'));
      return null;
    }
  }

  Future save() async {
    if (_key.currentState!.validate()) {
      try {
        final url = Uri.parse('${dotenv.get('API')}/sellers');
        final headers = {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        };

        var documentPks = [];
        for (var document in documents) {
          documentPks.add(document['pk']);
        }

        var photoPks = [];
        for (var photo in photos) {
          photoPks.add(photo['pk']);
        }

        var body = {
          'province': provinceValue,
          'city': cityValue,
          'area': areaValue,
          'address': addressController.text,
          'documents': documentPks.join(','),
          'photos': photoPks.join(','),
        };

        var res = await http.post(url, headers: headers, body: body);

        if (res.statusCode == 200) {
          var result = json.decode(res.body);

          storage.write(
              key: "producer", value: result['data']['pk'].toString());

          if (!context.mounted) return;
          ArtDialogResponse response = await ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "Success!",
                text:
                    "You are now a producer. You will be redirected to the producer's page."),
          );

          if (response.isTapConfirmButton) {
            if (!mounted) return;
            var jwt = AppDefaults.jwtDecode(token);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyProducerPage(
                    accountPk: jwt['sub'].toString(), token: token),
              ),
            );
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
                            'Registration as Producer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Province',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: AppDefaults.height,
                          // padding: EdgeInsets.zero,
                          child: DropdownButtonFormField<String>(
                            isDense: true,
                            value: provinceValue,
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
                              // print('provinces $value');
                              setState(() {
                                provinceValue = value!;
                                cityValue = '0';
                                areaValue = '0';
                                getCities();
                              });
                            },
                            items: provinces
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value['province_code'].toString(),
                                child: Text('${value['name']}'),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'City',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: AppDefaults.height,
                          // padding: EdgeInsets.zero,
                          child: DropdownButtonFormField<String>(
                            isDense: true,
                            value: cityValue,
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
                                cityValue = value!;
                                getAreas();
                              });
                            },
                            items:
                                cities.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value['city_code'].toString(),
                                child: Text('${value['name']}'),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Area',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: AppDefaults.height,
                          child: DropdownButtonFormField<String>(
                            isDense: true,
                            value: areaValue,
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
                                areaValue = value!;
                              });
                            },
                            items: areas.map<DropdownMenuItem<String>>((value) {
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
                            'Address Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 70.0,
                          padding: EdgeInsets.zero,
                          child: TextFormField(
                            controller: addressController,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '* Required';
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
                            // decoration: InputDecoration(
                            //   isDense: true,
                            //   contentPadding:
                            //       const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            //   prefixIconConstraints: const BoxConstraints(
                            //       minWidth: 0, minHeight: 0),
                            //   focusedBorder:
                            //       AppDefaults.outlineInputBorderSuccess,
                            //   enabledBorder:
                            //       AppDefaults.outlineInputBorderSuccess,
                            //   focusedErrorBorder:
                            //       AppDefaults.outlineInputBorderError,
                            //   errorBorder: AppDefaults.outlineInputBorderError,
                            // ),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin + 30),
                        const Text(
                          'Submit any of the following documents as proof of ownership:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10, bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.grey2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('1. Barangay certification'),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10, bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.grey2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('2. DTI certificate'),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10, bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.grey2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('3. Contract of lease'),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10, bottom: 5),
                          decoration: BoxDecoration(
                            color: AppColors.grey2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('4. etc.'),
                        ),
                        const SizedBox(height: AppDefaults.margin * 2),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Attach Documents here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        Visibility(
                          visible: documents.isNotEmpty ? true : false,
                          child: Column(
                            children: List.generate(
                              documents.length,
                              (index) {
                                return const Row(
                                  children: [
                                    // Badge(
                                    //   toAnimate: false,
                                    //   shape: BadgeShape.square,
                                    //   badgeColor: Colors.grey,
                                    //   borderRadius: BorderRadius.circular(8),
                                    //   badgeContent: Row(
                                    //     children: [
                                    //       const Icon(
                                    //         Icons.attach_file,
                                    //         size: AppDefaults.fontSize,
                                    //         color: Colors.white,
                                    //       ),
                                    //       SizedBox(
                                    //         height: 20,
                                    //         child: TextButton(
                                    //           style: TextButton.styleFrom(
                                    //             padding:
                                    //                 const EdgeInsets.all(0),
                                    //             textStyle: const TextStyle(
                                    //                 fontSize:
                                    //                     AppDefaults.fontSize),
                                    //           ),
                                    //           onPressed: () async {
                                    //             ArtDialogResponse response =
                                    //                 await ArtSweetAlert.show(
                                    //               barrierDismissible: false,
                                    //               context: context,
                                    //               artDialogArgs: ArtDialogArgs(
                                    //                 showCancelBtn: true,
                                    //                 title:
                                    //                     "Do you want to remove ${documents[index]['original_name']}?",
                                    //                 confirmButtonText: "Remove",
                                    //               ),
                                    //             );

                                    //             if (response
                                    //                 .isTapConfirmButton) {
                                    //               remove('documents', index);
                                    //               return;
                                    //             }
                                    //           },
                                    //           child: Text(
                                    //             documents[index]
                                    //                     ['original_name'] ??
                                    //                 '',
                                    //             style: const TextStyle(
                                    //               color: Colors.white,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    SizedBox(height: 35),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin / 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDefaults.radius - 10),
                                ),
                              ),
                              onPressed: () {
                                pickFile(
                                    'documents', ['jpg', 'png', 'pdf', 'doc']);
                              },
                              child: const Text('+ Add Documents'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDefaults.margin * 2),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Attach Display Photo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        Visibility(
                          visible: photos.isNotEmpty ? true : false,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: List.generate(
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
                                            '${dotenv.get('API')}/${photos[index]['path']}',
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
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDefaults.radius - 10),
                                ),
                              ),
                              onPressed: () {
                                pickFile('photos', ['jpg', 'png']);
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
