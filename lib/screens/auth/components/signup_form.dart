import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:market/screens/terms/terms_page.dart';

import '../../../components/icon_with_background.dart';
import '../../../constants/index.dart';
import '../../approot/app_root.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController birthday = TextEditingController();
  bool accept = false;

  @override
  void initState() {
    birthday.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Form(
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                prefixIcon: IconWithBackground(iconData: IconlyBold.profile),
                labelText: 'First Name',
                hintText: 'John',
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: IconWithBackground(iconData: IconlyBold.profile),
                labelText: 'Last Name',
                hintText: 'Doe',
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            TextField(
              controller: birthday,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      1900), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement

                  setState(() {
                    birthday.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              },
              decoration: const InputDecoration(
                prefixIcon: IconWithBackground(iconData: IconlyBold.calendar),
                labelText: 'Birthday',
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: IconWithBackground(iconData: IconlyBold.message),
                labelText: 'Email Address',
                hintText: 'you@email.com',
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: IconWithBackground(iconData: IconlyBold.lock),
                labelText: 'Password',
                hintText: '*********',
              ),
            ),
            // Forgot Password Button
            const SizedBox(height: AppDefaults.margin),
            Row(
              children: [
                // const Text('I accept all the '),
                Text(
                  'I have read and agree to the Terms',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Stack(
                  children: [
                    Switch(
                      value: accept,
                      onChanged: (value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TermsPage(),
                          ),
                        );
                        setState(() {
                          accept = value;
                          print(accept);
                        });
                      },
                      activeTrackColor: Colors.grey,
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AppRoot(),
                    ),
                  );
                },
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
