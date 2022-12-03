import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/select_dropdown.dart';
import 'package:market/screens/chat/conversation_list.dart';

import 'package:ably_flutter/ably_flutter.dart' as ably;
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
  Map<String, dynamic> account = {};
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
    var pk = AppDefaults.jwtDecode(token);
    fetchUser(pk['sub']);
    fetch();
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

  void initAbly() {
    String chatId = 'user-${account['user']['pk'].toString()}';
    print('listening to $chatId');
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
      print('chatpage message received');
      // Handle channel messages with name 'event1'
      // final player = AudioPlayer();
      // player.play(AssetSource('chat.mp3'));

      // print('StreamSubscription');
      // print(message.data);
      fetch();
    });
  }

  Future playLocal() async {
    print('playing local');
    final player = AudioPlayer();
    player.play(AssetSource('sounds/chat.mp3'));
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
