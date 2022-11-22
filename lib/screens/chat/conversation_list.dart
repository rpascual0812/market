import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/chat/bubble.dart';
import 'package:http/http.dart' as http;

class ConversationList extends StatefulWidget {
  const ConversationList({
    Key? key,
    required this.token,
    required this.chat,
  }) : super(key: key);

  final String token;
  final Map<String, dynamic> chat;

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  final storage = const FlutterSecureStorage();
  List chats = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetch() async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/chats');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
      };

      var res = await http.get(
        url,
        headers: headers,
      );

      if (res.statusCode == 200) {
        Map<Object, dynamic> dataJson = jsonDecode(res.body);
        print('chats $dataJson');
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Bubble();
            },
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.chat['imageUrl'] ?? ''),
                    maxRadius: 20,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.chat['name'] ?? '',
                            style: const TextStyle(
                              fontSize: AppDefaults.fontSize + 1,
                              // fontWeight: !widget.chat['messagesRead']
                              //     ? FontWeight.bold
                              //     : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.chat['messageText'] ?? '',
                            style: const TextStyle(
                              fontSize: AppDefaults.fontSize - 1,
                              // color: Colors.grey.shade600,
                              // fontWeight: !widget.chat['messagesRead']
                              //     ? FontWeight.bold
                              //     : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.chat['time'] ?? '',
              style: const TextStyle(
                fontSize: AppDefaults.fontSize - 2,
                // fontWeight: !widget.chat['messagesRead']
                //     ? FontWeight.bold
                //     : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
