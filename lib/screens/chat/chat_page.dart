import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/screens/chat/conversation_list.dart';

import 'package:http/http.dart' as http;

import '../../constants/index.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final storage = const FlutterSecureStorage();
  final searchController = TextEditingController(text: '');

  String? token = '';
  List chats = [];

  int skip = 0;
  int take = 10;

  var filterValue = 'Show All';
  var filters = ['Show All', 'Show only unread', 'Mark all as read'];

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
    fetch();
  }

  Future<void> fetch() async {
    try {
      chats = [];
      final params = {
        'filter': filterValue,
        'keyword': searchController.text,
        'skip': skip.toString(),
        'take': take.toString(),
      };
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
        Map<Object, dynamic> dataJson = jsonDecode(res.body);
        for (var i = 0; i < dataJson['data'].length; i++) {
          chats.add(dataJson['data'][i]);
        }

        setState(() {});
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
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SelectDropdown(
                      width: 160,
                      height: 55,
                      options: filters,
                      defaultValue: filterValue,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                controller: searchController,
                onChanged: (value) => fetch(),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            chats.isNotEmpty
                ? ListView.builder(
                    itemCount: chats.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ConversationList(
                        token: token ?? '',
                        chat: chats[index],
                      );
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(height: AppDefaults.margin * 6),
                      Text(
                        'No conversations found',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
