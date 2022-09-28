// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:market/screens/terms/terms_page.dart';

import '../../../constants/index.dart';

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
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool accept = false;

  // Initial Selected Value
  String provinceValue = 'Item 1';

  // List of items in our dropdown menu
  var provinces = [
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

  Future signup() async {
    if (_key.currentState!.validate()) {
      try {
        var body = {};

        var res = await http.post(Uri.parse('${dotenv.get('API')}/register'),
            body: body);
        if (res.statusCode == 200) return res.body;
        return null;
      } on Exception {
        return null;
      }
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
                                  height: AppDefaults.height,
                                  // padding: EdgeInsets.zero,
                                  child: TextFormField(
                                    controller: firstNameController,
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
                                    'Last Name',
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
                                    controller: lastNameController,
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
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     'Last Name',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // TextField(
                                //   decoration: InputDecoration(
                                //     floatingLabelBehavior:
                                //         FloatingLabelBehavior.always,
                                //     // labelText: 'Last Name',
                                //     border: OutlineInputBorder(),
                                //   ),
                                // ),
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
                      height: AppDefaults.height,
                      // padding: EdgeInsets.zero,
                      child: TextFormField(
                        readOnly: true,
                        controller: birthdayController,
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 10.0),
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
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppDefaults.radius),
                            borderSide: const BorderSide(
                                width: 1.0, color: Colors.redAccent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppDefaults.radius),
                            borderSide: const BorderSide(
                                width: 1.0, color: Colors.redAccent),
                          ),
                        ),
                        style: const TextStyle(
                            fontSize: AppDefaults.fontSize), // <-- SEE HERE
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
                      height: AppDefaults.height,
                      // padding: EdgeInsets.zero,
                      child: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
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
                      height: AppDefaults.height,
                      // padding: EdgeInsets.zero,
                      child: TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        validator: validatePassword,
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
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppDefaults.radius),
                            borderSide: const BorderSide(
                                width: 1.0, color: Colors.redAccent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppDefaults.radius),
                            borderSide: const BorderSide(
                                width: 1.0, color: Colors.redAccent),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14), // <-- SEE HERE
                      ),
                    ),
                    const SizedBox(height: AppDefaults.margin),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Repeat Password',
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
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Conform password is required';
                          }
                          if (value != passwordController.text) {
                            return 'Confirm password does not match';
                          }
                          return null;
                        },
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
                        style: const TextStyle(fontSize: 14), // <-- SEE HERE
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
                                  height: AppDefaults.height,
                                  // padding: EdgeInsets.zero,
                                  child: TextFormField(
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
                                // const Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     'Province',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 1.0, vertical: 0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(12.0),
                                //     border: Border.all(
                                //       color: Colors.black,
                                //       style: BorderStyle.solid,
                                //       width: 1,
                                //     ),
                                //   ),
                                //   child: DropdownButtonHideUnderline(
                                //     child: DropdownButtonFormField<String>(
                                //       value: provinceValue,
                                //       icon:
                                //           const Icon(Icons.keyboard_arrow_down),
                                //       items: provinces.map((String province) {
                                //         return DropdownMenuItem(
                                //           value: province,
                                //           child: Text(province),
                                //         );
                                //       }).toList(),
                                //       onChanged: (String? newValue) {
                                //         setState(() {
                                //           provinceValue = newValue!;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),
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
                                  height: AppDefaults.height,
                                  // padding: EdgeInsets.zero,
                                  child: TextFormField(
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
                                // const Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     'City',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 1.0, vertical: 0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(12.0),
                                //     border: Border.all(
                                //       color: Colors.black,
                                //       style: BorderStyle.solid,
                                //       width: 1,
                                //     ),
                                //   ),
                                //   child: DropdownButtonHideUnderline(
                                //     child: DropdownButtonFormField<String>(
                                //       value: provinceValue,
                                //       icon:
                                //           const Icon(Icons.keyboard_arrow_down),
                                //       items: provinces.map((String province) {
                                //         return DropdownMenuItem(
                                //           value: province,
                                //           child: Text(province),
                                //         );
                                //       }).toList(),
                                //       onChanged: (String? newValue) {
                                //         setState(() {
                                //           provinceValue = newValue!;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),
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
                                  height: AppDefaults.height,
                                  // padding: EdgeInsets.zero,
                                  child: TextFormField(
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
                                // const Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     'Area',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 1.0, vertical: 0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(12.0),
                                //     border: Border.all(
                                //       color: Colors.black,
                                //       style: BorderStyle.solid,
                                //       width: 1,
                                //     ),
                                //   ),
                                //   child: DropdownButtonHideUnderline(
                                //     child: DropdownButtonFormField<String>(
                                //       value: provinceValue,
                                //       icon:
                                //           const Icon(Icons.keyboard_arrow_down),
                                //       items: provinces.map((String province) {
                                //         return DropdownMenuItem(
                                //           value: province,
                                //           child: Text(province),
                                //         );
                                //       }).toList(),
                                //       onChanged: (String? newValue) {
                                //         setState(() {
                                //           provinceValue = newValue!;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),
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
                              onPressed: () async {},
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
                              onPressed: () async {},
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
                          child: Switch(
                            value: accept,
                            onChanged: (value) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const TermsPage(),
                                ),
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
                            var account = await signup();
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
