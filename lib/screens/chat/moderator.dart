import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:http/http.dart' as http;
import 'package:market/screens/chat/moderator_bubble.dart';
import 'package:market/screens/chat/moderator_start_form.dart';

class Moderator extends StatefulWidget {
  const Moderator({Key? key}) : super(key: key);

  @override
  State<Moderator> createState() => _ModeratorState();
}

class _ModeratorState extends State<Moderator> {
  final storage = const FlutterSecureStorage();
  String? token = '';
  String? userPk = '';
  List chats = [];
  Map<String, dynamic> account = {};

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getStorage() async {
    token = await storage.read(key: 'jwt');
    var pk = AppDefaults.jwtDecode(token);
    fetchUser(pk['sub']);
  }

  Future fetchUser(int pk) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$pk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          account = json.decode(res.body);
          // print('account ${account['user']}');
          userPk = account['user']['pk'].toString();
          fetch();
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  Future fetch() async {
    try {
      final params = {'type': 'support', 'role': 'end-user'};
      final url = Uri.parse('${dotenv.get('API')}/chats')
          .replace(queryParameters: params);
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

      var res = await http.get(
        url,
        headers: headers,
      );

      if (res.statusCode == 200) {
        var dataJson = jsonDecode(res.body);
        // print(dataJson);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        setState(() {
          chats = data;
          // print('chats $data');
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

  @override
  Widget build(BuildContext context) {
    return chats.isEmpty
        ? ModeratorStartForm(
            userPk: userPk ?? '',
            token: token ?? '',
            callback: (status) {
              fetch();
            })
        : ModeratorBubble(
            userPk: userPk ?? '',
            token: token ?? '',
          );
  }
}
