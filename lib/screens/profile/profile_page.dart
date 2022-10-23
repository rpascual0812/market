import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/profile/components/profile_picture_section.dart';
import 'package:market/screens/profile/components/profile_settings.dart';

import '../approot/app_root.dart';
// import '../producer/producer_page/components/profile_picture_section.dart';
import 'components/profile_product.dart';

import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.token}) : super(key: key);

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
    accountPk = account['sub'];
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
    print('${dotenv.get('API')}/accounts/$accountPk');
    print(widget.token);
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$accountPk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $widget.token',
      };

      var res = await http.get(url, headers: headers);
      print('status : ${res.statusCode}');
      if (res.statusCode == 200) {
        setState(() {
          var userJson = jsonDecode(res.body);
          account = userJson;
          print('result ${account['user']}');
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  Future logout() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/logout');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $widget.token',
      };

      var res = await http.post(url, headers: headers);
      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        storage.write(key: "jwt", value: '');
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (account['user'] != null) {
      userImage = AppDefaults.userImage(account['user']['user_document']);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            Appbar(),

            // Profile Picture
            const ProfilePictureSection(),

            /// Statuses
            const ProfileProduct(),
            const SizedBox(height: AppDefaults.margin),

            ProfileSettings(),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: AppDefaults.height,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: ElevatedButton(
                  onPressed: () async {
                    var result = await logout();
                    if (result != null) {
                      await storage.deleteAll();
                      // ignore: use_build_context_synchronously
                      AppDefaults.toast(context, 'success',
                          AppMessage.getSuccess('LOGOUT_SUCCESS'));
                    }

                    Timer(
                      const Duration(seconds: 1),
                      () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppRoot(jwt: ''),
                          ),
                        )
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDefaults.radius),
                    ),
                  ),
                  child: const Text('Log Out'),
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
