import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:market/components/network_image.dart';
import 'package:market/constants/index.dart';
import 'package:http_parser/http_parser.dart';

class ComplaintNew extends StatefulWidget {
  const ComplaintNew({
    super.key,
    required this.token,
    required this.callback,
  });

  final String token;
  final void Function() callback;

  @override
  State<StatefulWidget> createState() => ComplaintNewState();
}

enum TypeOfComplain { product, transaction, producer }

class ComplaintNewState extends State<ComplaintNew>
    with SingleTickerProviderStateMixin {
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  String? type = 'product';
  List complaints = [];

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController subjectController = TextEditingController(text: '');
  TextEditingController messageController = TextEditingController(text: '');

  var body = {
    'type': 'product',
    'subject': '',
    'message': '',
  };

  List productPhotos = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  Future pickImage(String type, ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);

      final document = await upload(type, imageTemp);
      // print(document);
      Map<String, dynamic> json = jsonDecode(document);
      // print('document $document');

      productPhotos.add(json);
    } on Exception {
      AppDefaults.toast(
          context, 'error', AppMessage.getError('ERROR_IMAGE_FAILED'));
    }
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
      print('send $response');
      return await response.stream.bytesToString();
    } on Exception {
      AppDefaults.toast(
          context, 'error', AppMessage.getSuccess('ERROR_IMAGE_FAILED'));
      return null;
    }
  }

  Future save() async {
    if (_key.currentState!.validate()) {
      try {
        var productPhotoIds = [];
        for (var i = 0; i < productPhotos.length; i++) {
          productPhotoIds.add(productPhotos[i]['pk']);
        }

        body = {
          'subject': subjectController.text,
          'message': messageController.text,
          'product_photo':
              productPhotoIds.isNotEmpty ? productPhotoIds.join(",") : '',
          'type': type.toString()
        };

        final url = Uri.parse('${dotenv.get('API')}/complaints');
        final headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        };

        var res = await http.post(url, headers: headers, body: body);
        if (res.statusCode == 201) {
          widget.callback();
          if (!mounted) return;
          AppDefaults.toast(
            context,
            'success',
            AppMessage.getSuccess('COMPLAINT_SAVE'),
          );
          Navigator.pop(context);
        }
        return null;
      } on Exception {
        return null;
      }
    } else {
      AppDefaults.toast(context, 'error', AppMessage.getError('FORM_INVALID'));
    }
  }

  remove(int index) {
    setState(() {
      productPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 100, right: 20, bottom: 0, left: 20),
              // padding: const EdgeInsets.all(15.0),
              height: 730.0,
              decoration: ShapeDecoration(
                // color: const Color.fromRGBO(41, 167, 77, 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    width: double.infinity,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      clipBehavior: Clip.hardEdge,
                      children: <Widget>[
                        const Text(
                          'File a Complaint',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(close),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 638,
                    child: Padding(
                      // padding: const EdgeInsets.only(
                      //     top: 10, right: 10, bottom: 0, left: 10),
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            const SizedBox(height: AppDefaults.margin),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Choose type of complain',
                                style: TextStyle(
                                  fontSize: AppDefaults.fontSize + 3,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Wrap(
                              runSpacing: -20,
                              children: [
                                RadioListTile(
                                  title: const Text("Product Concerns"),
                                  value: "product",
                                  groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: const Text("Transaction Concerns"),
                                  value: "transaction",
                                  groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: const Text("Producer Concerns"),
                                  value: "producer",
                                  groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDefaults.margin),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'What\'s your complaint?',
                                style: TextStyle(
                                  fontSize: AppDefaults.fontSize + 3,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDefaults.margin),
                            SizedBox(
                              height: AppDefaults.height,
                              // padding: EdgeInsets.zero,
                              child: TextFormField(
                                controller: subjectController,
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return '* Subject is required';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Subject',
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Color(0xfff5f5f5),
                                ),
                                style: const TextStyle(
                                  fontSize: AppDefaults.fontSize,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDefaults.margin),
                            TextFormField(
                              controller: messageController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return '* Message is required';
                                }
                                return null;
                              },
                              onTap: () async {},
                              maxLines: 6,
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xfff5f5f5),
                              ),
                              style: const TextStyle(
                                fontSize: AppDefaults.fontSize,
                              ),
                            ),
                            const SizedBox(height: AppDefaults.margin),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Attach Product Photo',
                                style: TextStyle(
                                  fontSize: AppDefaults.fontSize + 3,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDefaults.margin),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: AppDefaults.height - 5,
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    pickImage('display', ImageSource.gallery);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDefaults.radius - 10),
                                    ),
                                  ),
                                  child: const Text('+ Add Photo'),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDefaults.margin),
                            // productPhotos.isNotEmpty
                            //     ? Align(
                            //         alignment: Alignment.center,
                            //         child: Container(
                            //           margin: const EdgeInsets.only(
                            //               right: 5, bottom: 5),
                            //           height: 75,
                            //           child: AspectRatio(
                            //             aspectRatio: 1 / 1,
                            //             child: NetworkImageWithLoader(
                            //                 '${dotenv.get('API')}/${productPhotos[index]?['path']}',
                            //                 false),
                            //           ),
                            //         ),
                            //       )
                            //     : const SizedBox(),
                            Visibility(
                              visible: productPhotos.isNotEmpty ? true : false,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: List.generate(
                                    productPhotos.length,
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
                                                  "Do you want to remove ${productPhotos[index]?['original_name']}?",
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
                                                '${productPhotos[index]?['path']}',
                                                false),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    width: double.infinity,
                    height: 62,
                    decoration: BoxDecoration(
                      color: const Color(0xffeaeaea),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: const Color(0xffeaeaea),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            topLeft: Radius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: AppDefaults.fontSize + 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        await save();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Send",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: AppDefaults.fontSize + 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
        ),
      ),
    );
  }
}
