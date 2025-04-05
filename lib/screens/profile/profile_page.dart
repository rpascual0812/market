import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/profile/components/profile_picture_section.dart';
import 'package:market/screens/profile/components/profile_settings.dart';

// import '../producer/producer_page/components/profile_picture_section.dart';

import 'package:http/http.dart' as http;

import '../approot/app_root.dart';
import 'components/profile_product.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.token});

  final String token;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> account = <String, dynamic>{};
  int accountPk = 0;

  @override
  void initState() {
    super.initState();

    var account = AppDefaults.jwtDecode(widget.token);
    accountPk = account != null ? account['sub'] : 0;
    // readStorage();
    fetch();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();
    super.dispose();
  }

  // Future<void> readStorage() async {
  //   final jwt = await storage.read(key: 'jwt');
  //   final user = AppDefaults.jwtDecode(jwt!);

  //   setState(() {
  //     isLoading = true;
  //     token = jwt;
  //     fetch(user['sub']);
  //   });
  // }

  Future fetch() async {
    // print('${dotenv.get('API')}/accounts/$accountPk');
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$accountPk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.get(url, headers: headers);
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
      log('ERROR $e');
      return null;
    }
  }

  Future logout() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/logout');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.post(url, headers: headers);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }

      return null;
    } on Exception catch (e) {
      log('ERROR $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // var userImage = '${dotenv.get('S3')}/images/user.png';
    // if (account['user'] != null) {
    //   userImage = AppDefaults.userImage(account['user']['user_document']);
    // }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            const Appbar(),

            // Profile Picture
            const ProfilePictureSection(),

            /// Statuses
            account['user'] != null
                ? ProfileProduct(token: widget.token, user: account['user'])
                : const SizedBox(height: 1),
            // const SizedBox(height: AppDefaults.margin),

            ProfileSettings(token: widget.token),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              // height: AppDefaults.height,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ElevatedButton(
                  onPressed: () async {
                    ArtDialogResponse response = await ArtSweetAlert.show(
                      barrierDismissible: false,
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                        denyButtonText: "No",
                        denyButtonColor: Colors.grey,
                        title: "Are you sure you want to log out?",
                        // text: "You won't be able to revert this!",
                        confirmButtonText: "Yes",
                        confirmButtonColor: AppColors.danger,
                        type: ArtSweetAlertType.question,
                      ),
                    );

                    if (response.isTapConfirmButton) {
                      var result = await logout();
                      if (result != null) {
                        await storage.delete(key: 'jwt');
                        // ignore: use_build_context_synchronously
                        AppDefaults.toast(context, 'success',
                            AppMessage.getSuccess('LOGOUT_SUCCESS'));
                      }

                      Timer(
                        const Duration(seconds: 1),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AppRoot(jwt: ''),
                            ),
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDefaults.radius),
                    ),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                        fontSize: AppDefaults.fontSize, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
