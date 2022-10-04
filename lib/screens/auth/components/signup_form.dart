import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:market/screens/auth/login_page.dart';
import 'package:market/screens/terms/terms_page.dart';

import '../../../constants/index.dart';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController firstNameController =
      TextEditingController(text: 'Rafael');
  TextEditingController lastNameController =
      TextEditingController(text: 'Pascual');
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: 'rpascual0812@gmail.com.au');
  TextEditingController mobileController =
      TextEditingController(text: '9162052424');
  TextEditingController passwordController =
      TextEditingController(text: '1Loveyou\$\$');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '1Loveyou\$\$');
  String provinceValue = 'Item 1';
  String cityValue = 'Item 1';
  String areaValue = 'Item 1';
  TextEditingController addressDetailsController =
      TextEditingController(text: 'Pasig');

  bool accept = false;

  File? displayPhoto;
  int displayPhotoPk = 0;
  File? idPhoto;
  int idPhotoPk = 0;

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
    'accept': '',
    'images': {'display': '', 'id': ''}
  };

  // List of items in our dropdown menu
  var provinces = [
    '',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void initState() {
    birthdayController.text = ""; //set the initial value of text field
    super.initState();
  }

  Future save() async {
    if (_key.currentState!.validate()) {
      try {
        body = {
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
          'accept': accept.toString(),
          'display_photo': displayPhotoPk.toString(),
          'id_photo': idPhotoPk.toString(),
        };
        // print(Uri.parse('${dotenv.get('API')}/register'));
        var res = await http.post(Uri.parse('${dotenv.get('API')}/register'),
            body: body);
        if (res.statusCode == 200) {
          if (!mounted) return;
          AppDefaults.toast(
              context, 'success', AppMessage.getSuccess('REGISTER_SUCCESS'));
          AppDefaults.navigate(context, const LoginPage());
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const LoginPage(),
          //   ),
          // );
          // return res.body;
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
      print(document);
      Map<String, dynamic> json = jsonDecode(document);
      print('document $document');
      if (type == 'display') {
        displayPhoto = imageTemp;
        displayPhotoPk = json['document']['pk'];
      } else if (type == 'id') {
        idPhoto = imageTemp;
        idPhotoPk = json['document']['pk'];
      }
    } on Exception {
      AppDefaults.toast(
          context, 'error', AppMessage.getSuccess('ERROR_IMAGE_FAILED'));
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
                        'Password',
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
                          focusedBorder: AppDefaults.outlineInputBorderSuccess,
                          enabledBorder: AppDefaults.outlineInputBorderSuccess,
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
                        'Confirm Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDefaults.fontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin / 2),
                    SizedBox(
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
                  ],
                ), //Container
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            // Address
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
                                    'Province',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDefaults.fontSize,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                SizedBox(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: provinceValue,
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            AppDefaults.edgeInsetDropdown,
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                                minWidth: 0, minHeight: 0),
                                        focusedBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        enabledBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        focusedErrorBorder:
                                            AppDefaults.outlineInputBorderError,
                                        errorBorder:
                                            AppDefaults.outlineInputBorderError,
                                      ),
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: provinces.map((String province) {
                                        return DropdownMenuItem(
                                          value: province,
                                          child: Text(
                                            province,
                                            style: const TextStyle(
                                                fontSize: AppDefaults.fontSize),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          provinceValue = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Column(
                              children: [
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
                                  // height: AppDefaults.height,
                                  // padding: const EdgeInsets.only(left: 10),
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(
                                  //     color: Colors.grey,
                                  //     width: 1,
                                  //     style: BorderStyle.solid,
                                  //   ),
                                  //   borderRadius: BorderRadius.circular(
                                  //       AppDefaults.radius),
                                  // ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: cityValue,
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            AppDefaults.edgeInsetDropdown,
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                                minWidth: 0, minHeight: 0),
                                        focusedBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        enabledBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        focusedErrorBorder:
                                            AppDefaults.outlineInputBorderError,
                                        errorBorder:
                                            AppDefaults.outlineInputBorderError,
                                      ),
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: provinces.map((String city) {
                                        return DropdownMenuItem(
                                          value: city,
                                          child: Text(
                                            city,
                                            style: const TextStyle(
                                                fontSize: AppDefaults.fontSize),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          cityValue = newValue!;
                                        });
                                      },
                                    ),
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
                                    'Area',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDefaults.fontSize,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                SizedBox(
                                  // height: AppDefaults.height,
                                  // padding: const EdgeInsets.only(left: 10),
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(
                                  //     color: Colors.grey,
                                  //     width: 1,
                                  //     style: BorderStyle.solid,
                                  //   ),
                                  //   borderRadius: BorderRadius.circular(
                                  //       AppDefaults.radius),
                                  // ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: areaValue,
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            AppDefaults.edgeInsetDropdown,
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                                minWidth: 0, minHeight: 0),
                                        focusedBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        enabledBorder: AppDefaults
                                            .outlineInputBorderSuccess,
                                        focusedErrorBorder:
                                            AppDefaults.outlineInputBorderError,
                                        errorBorder:
                                            AppDefaults.outlineInputBorderError,
                                      ),
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: provinces.map((String area) {
                                        return DropdownMenuItem(
                                          value: area,
                                          child: Text(
                                            area,
                                            style: const TextStyle(
                                                fontSize: AppDefaults.fontSize),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          areaValue = newValue!;
                                        });
                                      },
                                    ),
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
                                  borderRadius:
                                      BorderRadius.circular(AppDefaults.radius),
                                ),
                              ),
                              child: const Text('+ Add Photo'),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        displayPhoto != null
                            ? Image.file(
                                displayPhoto!,
                                height: 160,
                              )
                            : const SizedBox(),
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
                                  borderRadius:
                                      BorderRadius.circular(AppDefaults.radius),
                                ),
                              ),
                              child: const Text('Scan ID'),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDefaults.margin),
                        idPhoto != null
                            ? Image.file(
                                idPhoto!,
                                height: 160,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Attach Document 1',
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
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Attach Document 2',
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
            Container(
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
                              .bodyText1
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
                                        builder: (context) => const TermsPage(),
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
                              borderRadius:
                                  BorderRadius.circular(AppDefaults.radius),
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

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';
  }

  return null;
}

String? validateMobile(String? formMobile) {
  if (formMobile == null || formMobile.isEmpty) {
    return 'Mobile Number is required.';
  }

  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formMobile)) {
    return 'Mobile Number is invalid.';
  }

  return null;
}
