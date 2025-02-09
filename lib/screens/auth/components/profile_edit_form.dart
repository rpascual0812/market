import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:market/screens/terms/terms_page.dart';

import '../../../components/network_image.dart';
import '../../../constants/index.dart';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({
    super.key,
    required this.user,
    required this.callback,
  });

  final Map<String, dynamic> user;
  final void Function() callback;

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController mobileController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');

  TextEditingController addressDetailsController =
      TextEditingController(text: '');

  TextEditingController aboutMeController = TextEditingController(text: '');

  bool accept = false;

  Map<String, dynamic>? displayPhoto;
  Map<String, dynamic>? idPhoto;
  // File? displayPhoto;
  // int displayPhotoPk = 0;
  // File? idPhoto;
  // int idPhotoPk = 0;

  var body = {
    'first_name': '',
    'last_name': '',
    'birthday': '',
    'email': '',
    'mobile': '',
    'password': '',
    'province': '',
    'city': '',
    'area': '',
    'address_details': '',
    'about_me': '',
    'accept': '',
    'images': {'display': '', 'id': ''}
  };

  Map<String, dynamic> userAddress = {};

  // List of items in our dropdown menu
  List provinces = [];
  List cities = [];
  List areas = [];

  String provinceValue = 'select';
  String cityValue = 'select';
  String areaValue = 'select';

  @override
  void initState() {
    if (widget.user['user_addresses'] != null) {
      var defaultFound = false;
      for (var i = 0; i < widget.user['user_addresses'].length; i++) {
        if (widget.user['user_addresses'][i]['default']) {
          defaultFound = true;
          userAddress = widget.user['user_addresses'][i];
        }
      }

      if (!defaultFound) {
        userAddress = widget.user['user_addresses'][0];
      }

      if (userAddress.isNotEmpty) {
        addressDetailsController.text = userAddress['address'];
      }

      // userAddress = AppDefaults.userAddress(user['user_addresses']);
    }

    getProvinces(true);

    if (widget.user.isNotEmpty) {
      firstNameController.text = widget.user['first_name'] ?? '';
      lastNameController.text = widget.user['last_name'] ?? '';
      birthdayController.text = widget.user['birthdate'] ?? '';
      emailController.text = widget.user['email_address'] ?? '';
      mobileController.text = widget.user['mobile_number'] ?? '';
      aboutMeController.text = widget.user['about'] ?? '';
    }

    if (widget.user['user_document'].length > 0) {
      for (var i = 0; i < widget.user['user_document'].length; i++) {
        if (widget.user['user_document'][i]['type'] == 'profile_photo') {
          displayPhoto = widget.user['user_document'][i]['document'];
        } else if (widget.user['user_document'][i]['type'] == 'id_photo') {
          idPhoto = widget.user['user_document'][i]['document'];
        }
      }
    }

    super.initState();
  }

  Future getProvinces(firstLoad) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/provinces');
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          cities = [];
          areas = [];

          provinces = result['data'];
          provinces.insert(0, {'province_code': 'select', 'name': 'Select'});
          cityValue = 'select';
          areaValue = 'select';

          if (firstLoad && userAddress.isNotEmpty) {
            provinceValue = userAddress['province_code'].toString();

            getCities(true);
          }
        });
      }
      if (res.statusCode == 200) return res.body;
      return null;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future getCities(firstLoad) async {
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
          cities.insert(0, {'city_code': 'select', 'name': 'Select'});

          if (firstLoad && userAddress.isNotEmpty) {
            cityValue = userAddress['city_code'].toString();
            getAreas(true);
          }
        });
      }
      if (res.statusCode == 200) return res.body;
      return null;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future getAreas(firstLoad) async {
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
          areas.insert(0, {'pk': 'select', 'name': 'Select'});

          if (firstLoad && userAddress.isNotEmpty) {
            areaValue = userAddress['area_pk'].toString();
          }
        });
      }
      if (res.statusCode == 200) return res.body;
      return null;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future save() async {
    if (_key.currentState!.validate()) {
      try {
        body = {
          'pk': widget.user['pk'].toString(),
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'birthday': birthdayController.text.toString(),
          'email': emailController.text,
          'mobile': mobileController.text.toString(),
          'password': passwordController.text,
          'province': provinceValue,
          'city': cityValue,
          'area': areaValue,
          'address_details': addressDetailsController.text,
          'about': aboutMeController.text,
          'accept': accept.toString(),
          'display_photo': displayPhoto!['pk'].toString(),
          'id_photo': idPhoto!['pk'].toString(),
        };

        // print(Uri.parse('${dotenv.get('API')}/register'));
        var url = widget.user['pk'] != null
            ? '${dotenv.get('API')}/users/update'
            : '${dotenv.get('API')}/register';

        var res = await http.post(Uri.parse(url), body: body);

        // print(res.statusCode);
        if (res.statusCode == 201) {
          if (!mounted) return;
          // print(AppMessage.getSuccess('REGISTER_SUCCESS'));
          AppDefaults.toast(
              context,
              'success',
              AppMessage.getSuccess(
                  widget.user.isEmpty ? 'REGISTER_SUCCESS' : 'PROFILE_UPDATE'));
          Navigator.pop(context);

          widget.callback();
        }
        return null;
      } on Exception {
        return null;
      }
    } else {
      accept
          ? AppDefaults.toast(
              context, 'error', AppMessage.getError('FORM_INVALID'))
          : AppDefaults.toast(
              context, 'error', AppMessage.getError('TERMS_REQUIRED'));
    }
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
      if (type == 'display') {
        displayPhoto = json['document'];
        // displayPhoto = imageTemp;
        // displayPhotoPk = json['document']['pk'];
      } else if (type == 'id') {
        idPhoto = json['document'];
        // idPhoto = imageTemp;
        // idPhotoPk = json['document']['pk'];
      }
    } on Exception {
      AppDefaults.toast(
          context, 'error', AppMessage.getError('ERROR_IMAGE_FAILED'));
    }
  }

  // Future openCamera() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.camera);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);

  //     idPhoto = imageTemp;
  //     final path = await upload('id', imageTemp);
  //     idPhoto = imageTemp;
  //     idPhotoNetwork = path.toString();
  //   } on Exception {
  //     AppDefaults.toast(
  //         context, 'error', AppMessage.getSuccess('ERROR_IMAGE_FAILED'));
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Form(
        key: _key,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    const SizedBox(height: AppDefaults.margin * 1),
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
                                    'First Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDefaults.fontSize,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                SizedBox(
                                  child: TextFormField(
                                    controller: firstNameController,
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'First Name is required';
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
                                    'Last Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDefaults.fontSize,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                SizedBox(
                                  child: TextFormField(
                                    controller: lastNameController,
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Last Name is required';
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
                        'Birthday',
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
                        readOnly: true,
                        controller: birthdayController,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Birthday is required';
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                1900), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              birthdayController.text =
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
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                          focusedBorder: AppDefaults.outlineInputBorderSuccess,
                          enabledBorder: AppDefaults.outlineInputBorderSuccess,
                          focusedErrorBorder:
                              AppDefaults.outlineInputBorderError,
                          errorBorder: AppDefaults.outlineInputBorderError,
                        ),
                        style: AppDefaults.formTextStyle,
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDefaults.fontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin / 2),
                    SizedBox(
                      // height: AppDefaults.height,
                      // padding: EdgeInsets.zero,
                      child: TextFormField(
                        controller: emailController,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: AppDefaults.edgeInset,
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                          focusedBorder: AppDefaults.outlineInputBorderSuccess,
                          enabledBorder: AppDefaults.outlineInputBorderSuccess,
                          focusedErrorBorder:
                              AppDefaults.outlineInputBorderError,
                          errorBorder: AppDefaults.outlineInputBorderError,
                        ),
                        style: AppDefaults.formTextStyle,
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDefaults.fontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin / 2),
                    SizedBox(
                      // height: AppDefaults.height,
                      // padding: EdgeInsets.zero,
                      child: TextFormField(
                        controller: mobileController,
                        validator: validateMobile,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: AppDefaults.edgeInset,
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                          focusedBorder: AppDefaults.outlineInputBorderSuccess,
                          enabledBorder: AppDefaults.outlineInputBorderSuccess,
                          focusedErrorBorder:
                              AppDefaults.outlineInputBorderError,
                          errorBorder: AppDefaults.outlineInputBorderError,
                          prefixIcon: const Padding(
                              padding: EdgeInsets.all(10), child: Text('+63 ')),
                        ),
                        style: const TextStyle(
                            fontSize: AppDefaults.fontSize), // <-- SEE HERE
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'About Me',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDefaults.fontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin / 2),
                    SizedBox(
                      child: TextFormField(
                        maxLines: 5,
                        controller: aboutMeController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: AppDefaults.edgeInset,
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                          focusedBorder: AppDefaults.outlineInputBorderSuccess,
                          enabledBorder: AppDefaults.outlineInputBorderSuccess,
                          focusedErrorBorder:
                              AppDefaults.outlineInputBorderError,
                          errorBorder: AppDefaults.outlineInputBorderError,
                        ),
                        style: const TextStyle(fontSize: AppDefaults.fontSize),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    Visibility(
                      visible: widget.user.isNotEmpty ? false : true,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDefaults.fontSize,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: widget.user.isNotEmpty ? false : true,
                        child: const SizedBox(height: AppDefaults.margin / 2)),
                    Visibility(
                      visible: widget.user.isNotEmpty ? false : true,
                      child: SizedBox(
                        // padding: EdgeInsets.zero,
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          validator: validatePassword,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: AppDefaults.edgeInset,
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            // contentPadding: const EdgeInsets.only(left: 10, right: 10),
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
                    ),
                    Visibility(
                        visible: widget.user.isNotEmpty ? false : true,
                        child: const SizedBox(height: AppDefaults.margin)),
                    Visibility(
                      visible: widget.user.isNotEmpty ? false : true,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDefaults.fontSize,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: widget.user.isNotEmpty ? false : true,
                        child: const SizedBox(height: AppDefaults.margin / 2)),
                    Visibility(
                      visible: widget.user.isNotEmpty ? false : true,
                      child: SizedBox(
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Confirm password is required';
                            }
                            if (value != passwordController.text) {
                              return 'Confirm password does not match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: AppDefaults.edgeInset,
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                            focusedBorder:
                                AppDefaults.outlineInputBorderSuccess,
                            enabledBorder:
                                AppDefaults.outlineInputBorderSuccess,
                            focusedErrorBorder:
                                AppDefaults.outlineInputBorderError,
                            errorBorder: AppDefaults.outlineInputBorderError,
                          ),
                          style:
                              const TextStyle(fontSize: AppDefaults.fontSize),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: widget.user.isNotEmpty ? false : true,
                        child: const SizedBox(height: AppDefaults.margin)),
                  ],
                ), //Container
              ),
            ),
            Visibility(
                visible: widget.user.isNotEmpty ? false : true,
                child: const SizedBox(height: AppDefaults.margin)),
            // Address
            Visibility(
              visible: true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDefaults.margin * 1),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Province',
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
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
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
                              provinceValue = value!;
                              cityValue = 'select';
                              areaValue = 'select';
                            });

                            getCities(false);
                          },
                          items:
                              provinces.map<DropdownMenuItem<String>>((value) {
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
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
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
                              areaValue = 'select';
                            });
                            getAreas(false);
                          },
                          items: cities.map<DropdownMenuItem<String>>((value) {
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDefaults.fontSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDefaults.margin / 2),
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
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Address Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppDefaults.fontSize,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDefaults.margin / 2),
                            SizedBox(
                              child: TextFormField(
                                controller: addressDetailsController,
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Address Details is required';
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
                          ],
                        ),
                      ),

                      // const Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     'Address Details',
                      //     style: TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // const TextField(
                      //   keyboardType: TextInputType.text,
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     floatingLabelBehavior: FloatingLabelBehavior.always,
                      //   ),
                      // ),
                      const SizedBox(height: AppDefaults.margin),
                    ],
                  ), //Container
                ),
              ),
            ),

            const SizedBox(height: AppDefaults.margin),
            // Display Photo
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Attach Display Photo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    displayPhoto != null
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 5, bottom: 5),
                              height: 75,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: NetworkImageWithLoader(
                                    '${dotenv.get('API')}/${displayPhoto!['path']}',
                                    false),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: AppDefaults.height,
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
                      ],
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Verify Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    idPhoto != null
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 5, bottom: 5),
                              height: 75,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: NetworkImageWithLoader(
                                    '${dotenv.get('API')}/${idPhoto!['path']}',
                                    false),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: AppDefaults.height,
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: ElevatedButton(
                              onPressed: () async {
                                pickImage('id', ImageSource.camera);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDefaults.radius - 10),
                                ),
                              ),
                              child: const Text('Scan ID'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    // const Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Attach Document 1',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: AppDefaults.fontSize,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: AppDefaults.margin / 2),
                    // SizedBox(
                    //   height: AppDefaults.height,
                    //   // padding: EdgeInsets.zero,
                    //   child: TextFormField(
                    //     decoration: InputDecoration(
                    //       // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius:
                    //             BorderRadius.circular(AppDefaults.radius),
                    //         borderSide: const BorderSide(
                    //             width: 1.0, color: Colors.grey),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius:
                    //             BorderRadius.circular(AppDefaults.radius),
                    //         borderSide: const BorderSide(
                    //             width: 1.0, color: Colors.grey),
                    //       ),
                    //     ),
                    //     style: const TextStyle(
                    //         fontSize: AppDefaults.fontSize), // <-- SEE HERE
                    //   ),
                    // ),
                    // const Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Attach Document 1',
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // const TextField(
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration: InputDecoration(
                    //     // prefixIcon: IconWithBackground(iconData: IconlyBold.message),
                    //     // labelText: 'Email Address',
                    //     // hintText: 'you@email.com',
                    //     border: OutlineInputBorder(),
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //   ),
                    // ),
                    // const SizedBox(height: AppDefaults.margin),
                    // const Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Attach Document 2',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: AppDefaults.fontSize,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: AppDefaults.margin / 2),
                    // SizedBox(
                    //   height: AppDefaults.height,
                    //   // padding: EdgeInsets.zero,
                    //   child: TextFormField(
                    //     decoration: InputDecoration(
                    //       // contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius:
                    //             BorderRadius.circular(AppDefaults.radius),
                    //         borderSide: const BorderSide(
                    //             width: 1.0, color: Colors.grey),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius:
                    //             BorderRadius.circular(AppDefaults.radius),
                    //         borderSide: const BorderSide(
                    //             width: 1.0, color: Colors.grey),
                    //       ),
                    //     ),
                    //     style: const TextStyle(
                    //         fontSize: AppDefaults.fontSize), // <-- SEE HERE
                    //   ),
                    // ),
                    // const Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Attach Document 2',
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // const TextField(
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration: InputDecoration(
                    //     // prefixIcon: IconWithBackground(iconData: IconlyBold.message),
                    //     // labelText: 'Email Address',
                    //     // hintText: 'you@email.com',
                    //     border: OutlineInputBorder(),
                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                    //   ),
                    // ),
                    const SizedBox(height: AppDefaults.margin),
                  ],
                ), //Container
              ),
            ),

            const SizedBox(height: AppDefaults.margin),
            // Terms
            Visibility(
              visible: widget.user.isNotEmpty ? false : true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'I have read and agree to the Terms',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppDefaults.fontSize),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FormField(
                              initialValue: false,
                              validator: (value) {
                                if (value == false) {
                                  return AppMessage.getError('TERMS_REQUIRED');
                                }
                                return null;
                              },
                              builder: (FormFieldState<bool> field) {
                                return Switch(
                                  value: accept,
                                  onChanged: (value) {
                                    accept = !accept;
                                    field.didChange(value);
                                    if (accept) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const TermsPage(
                                              location: 'profile'),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDefaults.margin),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: AppDefaults.height,
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: ElevatedButton(
                            onPressed: () async {
                              var account = await save();
                              if (account != null) {}
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDefaults.radius - 10),
                              ),
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDefaults.margin),
                    ],
                  ), //Container
                ),
              ),
            ),
            Visibility(
              visible: widget.user.isNotEmpty ? true : false,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: AppDefaults.height,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () async {
                      var account = await save();
                      if (account != null) {}
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDefaults.radius - 10),
                      ),
                    ),
                    child: const Text('Update'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDefaults.margin * 2),
          ],
        ),
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required.';
  }

  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return '''
      Password must be at least 8 characters,
      include an uppercase letter, and number.
      ''';
  }

  return null;
}

String? validateMobile(String? formMobile) {
  if (formMobile == null || formMobile.isEmpty) {
    return 'Mobile Number is required.';
  }

  // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  // RegExp regex = RegExp(pattern);
  // if (!regex.hasMatch(formMobile)) {
  //   return 'Mobile Number is invalid.';
  // }

  return null;
}
