import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/chat/bubble.dart';
import 'package:time_elapsed/time_elapsed.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
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
  Map<String, dynamic> account = {};

  @override
  void initState() {
    super.initState();
    var pk = AppDefaults.jwtDecode(widget.token);
    fetchUser(pk['sub']);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future fetchUser(int pk) async {
    try {
      final url = Uri.parse('${dotenv.get('API')}/accounts/$pk');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          account = json.decode(res.body);
          initAbly();
          // print(account);
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  void initAbly() {
    print('conversation list initAbly');
    String chatId = 'user-${account['user']['pk'].toString()}';
    // Create an instance of ClientOptions with Ably key
    final clientOptions = ably.ClientOptions(key: dotenv.get('ABLY_KEY'));

    // Use ClientOptions to create Realtime or REST instance
    ably.Realtime realtime = ably.Realtime(options: clientOptions);

    realtime.connection.on().listen(
      (ably.ConnectionStateChange stateChange) async {
        // Handle connection state change events
        // print('realtime connection');
        // AppDefaults.toast(context, 'success', 'Realtime Connection');
      },
    );

    ably.RealtimeChannel channel = realtime.channels.get(chatId);
    channel.on().listen((ably.ChannelStateChange stateChange) async {
      // Handle channel state change events
      // print('RealtimeChannel');
      // AppDefaults.toast(context, 'success', 'RealtimeChannel');
    });

    StreamSubscription<ably.Message> subscription =
        channel.subscribe(name: chatId).listen((ably.Message message) {
      // Handle channel messages with name 'event1'
      print('StreamSubscription');
      print(message.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    var image = widget.chat.isNotEmpty &&
            widget.chat['chat_participants'].length > 0
        ? '${dotenv.get('API')}/${widget.chat['chat_participants'][0]['user']['user_document']['document']['path']}'
        : '';
    var name = widget.chat.isNotEmpty &&
            widget.chat['chat_participants'].length > 0
        ? '${widget.chat['chat_participants'][0]['user']['first_name']} ${widget.chat['chat_participant']['user']['last_name']}'
        : '';
    var date = TimeElapsed.fromDateStr(widget.chat['last_message_date']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Bubble(
                userPk: widget.chat['chat_participants'][0]['pk'].toString(),
                token: widget.token,
              );
            },
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 30, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(image),
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
                            name,
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
                            widget.chat['last_message'] ?? '',
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
                  Text(date == 'Now' ? 'Just $date' : '$date ago'),
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
