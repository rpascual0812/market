import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
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
  final ScrollController _scrollController = ScrollController();
  final storage = const FlutterSecureStorage();
  final searchController = TextEditingController(text: '');

  String? token = '';
  Map<String, dynamic> account = {};
  List chats = [];

  int page = 0;
  int skip = 0;
  int take = 10;

  var filterValue = 'Show All';
  var filters = ['Show All', 'Show only unread', 'Mark all as read'];

  bool everyThingLoaded = false;

  @override
  void initState() {
    super.initState();

    getStorage();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadInitialData() async {
    chats = await getNextPageData(page);
    // print('load initial data $products');
    setState(() {});
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      chats += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
  }

  Future getStorage() async {
    token = await storage.read(key: 'jwt');
    var pk = AppDefaults.jwtDecode(token);
    fetchUser(pk['sub']);
    loadInitialData();
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

  Future fetch() async {
    try {
      final params = {
        'filter': filterValue,
        'keyword': searchController.text,
        'type': 'chat',
        'role': 'end-user',
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
        // Map<Object, dynamic> dataJson = jsonDecode(res.body);
        // for (var i = 0; i < dataJson['data'].length; i++) {
        //   chats.add(dataJson['data'][i]);
        // }
        var dataJson = jsonDecode(res.body);
        // print(dataJson);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (data.length <= take) {
          everyThingLoaded = true;
        }
        // print('chats $data');
        return data;
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
      // print('chatpage message received');
      // Handle channel messages with name 'event1'
      // final player = AudioPlayer();
      // player.play(AssetSource('chat.mp3'));

      // print('StreamSubscription');
      // print(message.data);
      fetch();
    });
  }

  Future getNextPageData(int page) async {
    return await fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        controller: _scrollController,
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
                ? InfiniteScrollList(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    onLoadingStart: (page) async {
                      // List<String> newData = await getNextPageData(page);
                      // setState(() {
                      //   // data += newData;
                      //   if (newData.isEmpty) {
                      //     everyThingLoaded = true;
                      //   }
                      // });
                    },
                    everythingLoaded: everyThingLoaded,
                    children: chats
                        .map((chat) => ListItem(
                            token: token ?? '', account: account, chat: chat))
                        .toList(),
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
            // chats.isNotEmpty
            //     ? ListView.builder(
            //         itemCount: chats.length,
            //         shrinkWrap: true,
            //         padding: const EdgeInsets.only(top: 16),
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemBuilder: (context, index) {
            //           return ConversationList(
            //             token: token ?? '',
            //             chat: chats[index],
            //           );
            //         },
            //       )
            //     : Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: const [
            //           SizedBox(height: AppDefaults.margin * 6),
            //           Text(
            //             'No conversations found',
            //             style: TextStyle(color: Colors.black, fontSize: 15),
            //           )
            //         ],
            //       ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String token;
  final Map<String, dynamic> account;
  final Map<String, dynamic> chat;
  const ListItem({
    Key? key,
    required this.token,
    required this.account,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConversationList(
      token: token,
      account: account,
      chat: chat,
    );
  }
}
