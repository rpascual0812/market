import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/producer/producer_page/producer_page.dart';
import 'package:market/screens/producer/producer_profile/producer_profile.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:http/http.dart' as http;

class Bubble extends StatefulWidget {
  const Bubble({
    super.key,
    required this.userPk,
    required this.token,
    required this.callback,
  });

  final String userPk;
  final String token;
  final void Function(bool)? callback;

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  final clientOptions = ably.ClientOptions(key: dotenv.get('ABLY_KEY'));

  var chatId = '';
  String image = '';
  String name = '';
  int userPk = 0;

  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // bool _firstAutoscrollExecuted = false;
  // bool _shouldAutoscroll = false;
  Map<String, dynamic> account = {};
  Map<String, dynamic> chat = {};
  List messages = [];

  int skip = 0;
  int take = 10;

  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    var token = AppDefaults.jwtDecode(widget.token);
    fetchAccount(token['sub']);
    setRead();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future fetchAccount(int pk) async {
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
          // print('account $account');
          fetchChat();
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  Future fetchChat() async {
    // print('fetching chat ${widget.userPk}');
    try {
      final params = {'type': 'chat'};
      final url = Uri.parse('${dotenv.get('API')}/chats/user/${widget.userPk}')
          .replace(queryParameters: params);
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.get(url, headers: headers);
      // print('res ${res.statusCode}');
      // print('res body ${res.body}');
      if (res.statusCode == 200) {
        setState(() {
          image = '';
          name = '';
          chat = json.decode(res.body);
          // print('fetchchat $chat');
          readMessages();
          fetchMessages();
          initAbly();
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  Future fetchMessages() async {
    try {
      final params = {'skip': skip.toString(), 'take': take.toString()};
      final url = Uri.parse('${dotenv.get('API')}/chats/${chat['pk']}/messages')
          .replace(queryParameters: params);
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.get(url, headers: headers);
      // log(res.statusCode.toString());
      if (res.statusCode == 200) {
        setState(() {
          var data = json.decode(res.body);
          messages = data['data'];
          _scrollToBottom();
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
  }

  void _scrollToBottom() async {
    // print('Scrollling to bottom');
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    Future.delayed(const Duration(milliseconds: 500), () {
      // print('Scrolled to bottom');
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.fastOutSlowIn,
    // );
  }

  void _scrollListener() {
    // _firstAutoscrollExecuted = true;

    // if (_scrollController.hasClients &&
    //     _scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //   _shouldAutoscroll = true;
    // } else {
    //   _shouldAutoscroll = false;
    // }
  }

  void initAbly() {
    chatId = chat['uuid'] ?? '';
    print('listening to bubble chat id: $chatId');

    // Create an instance of ClientOptions with Ably key
    // final clientOptions = ably.ClientOptions(key: dotenv.get('ABLY_KEY'));

    // Use ClientOptions to create Realtime or REST instance
    ably.Realtime realtime = ably.Realtime(options: clientOptions);

    // realtime.connection.on().listen(
    //   (ably.ConnectionStateChange stateChange) async {
    //     // Handle connection state change events
    //     // print('realtime connection');
    //     // AppDefaults.toast(context, 'success', 'Realtime Connection');
    //   },
    // );

    ably.RealtimeChannel channel = realtime.channels.get(chatId);
    channel.on().listen((ably.ChannelStateChange stateChange) async {
      // Handle channel state change events
      // print('RealtimeChannel');
      // AppDefaults.toast(context, 'success', 'RealtimeChannel');
    });

    StreamSubscription<ably.Message> subscription =
        channel.subscribe(name: chatId).listen((ably.Message message) {
      // Handle channel messages with name 'event1'
      // print('StreamSubscription');
      // print(message.data);
      // print(account['user']['pk']);

      final player = AudioPlayer();
      if (message.data != null) {
        var newMessage = message.data;
        if (newMessage != null &&
            account['user']['pk'].toString() ==
                (newMessage as dynamic)['user_pk'].toString()) {
          player.play(AssetSource('sent.mp3'));
        } else {
          player.play(AssetSource('received.mp3'));
        }
      }

      messages.insert(messages.length, message.data);
      _scrollToBottom();
      // print(messages);
    });
  }

  void setRead() async {
    try {
      final url =
          Uri.parse('${dotenv.get('API')}/chats/${chat['pk']}/message/read');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
      };

      var res = await http.post(url, headers: headers);
      widget.callback!(true);
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  void sendChat() async {
    if (messageController.text != '') {
      try {
        // print('account pk ${chat['uuid']} ${messageController.text}');
        var body = {
          'uuid': chat['uuid'],
          'message': messageController.text,
          'user_pk': account['user']['pk'].toString(),
        };
        // print('saving $body');
        // print(widget.token);
        // print(widget.userPk.toString());
        final url = Uri.parse('${dotenv.get('API')}/chats/messages');
        final headers = {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
        };

        var res = await http.post(url, headers: headers, body: body);
        if (res.statusCode == 200) {
          var ablyData = {
            'pk': messages.length + 1,
            'message': messageController.text,
            'user_pk': account['user']['pk'].toString(),
          };

          ably.Realtime realtime = ably.Realtime(options: clientOptions);
          ably.RealtimeChannel conversationChannel =
              realtime.channels.get('user-${userPk.toString()}');
          await conversationChannel.publish(
            name: 'user-${userPk.toString()}',
            data: ablyData,
          );
          // print('chatId $chatId');
          ably.RealtimeChannel bubbleChannel = realtime.channels.get(chatId);
          await bubbleChannel.publish(
            name: chatId,
            data: ablyData,
          );

          setState(() {
            // messages.insert(
            //   messages.length,
            //   {
            //     'pk': messages.length + 1,
            //     'messageContent': messageController.text,
            //     'messageType': "sender",
            //   },
            // );

            messageController.text = '';
            _scrollToBottom();
            // if (_scrollController.hasClients && _shouldAutoscroll) {
            //   _scrollToBottom();
            // }

            // if (!_firstAutoscrollExecuted && _scrollController.hasClients) {
            //   _scrollToBottom();
            // }
          });
        }
        return null;
      } on Exception catch (exception) {
        log('exception $exception');
      } catch (error) {
        log('error $error');
      }
    }

    // print('sending chat');
    // final clientOptions = ably.ClientOptions(key: dotenv.get('ABLY_KEY'));
  }

  void readMessages() async {
    // print('read messages $chat');
    try {
      final url =
          Uri.parse('${dotenv.get('API')}/chats/${chat['pk']}/messages/read');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
      };

      var res = await http.post(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {});
      }
      return null;
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    if (_keyboardVisible) {
      _scrollToBottom();
    }

    if (chat.isNotEmpty) {
      var found = false;
      for (var i = 0; i < chat['chat_participants'].length; i++) {
        if (chat['chat_participants'][i]['user']['pk'] !=
            account['user']['pk']) {
          found = true;
          image = chat['chat_participants'] != null
              ? '${dotenv.get('API')}/${chat['chat_participants'][i]['user']['user_document']['document']['path']}'
              : '';
          userPk = chat['chat_participants'] != null
              ? chat['chat_participants'][i]['user']['pk']
              : 0;
          name = chat['chat_participants'] != null
              ? '${chat['chat_participants'][i]['user']['first_name']} ${chat['chat_participants'][i]['user']['last_name']}'
              : '';
        }
      }

      if (!found) {
        image = chat['chat_participants'] != null
            ? '${dotenv.get('API')}/${chat['chat_participants'][0]['user']['user_document']['document']['path']}'
            : '';
        userPk = chat['chat_participants'] != null
            ? chat['chat_participants'][0]['user']['first_name']
            : 0;
        name = chat['chat_participants'] != null
            ? '${chat['chat_participants'][0]['user']['first_name']} ${chat['chat_participants'][0]['user']['last_name']}'
            : '';
      }
    }
    // print('userPK $userPk $name');
    image = image != '' ? image : '${dotenv.get('API')}/assets/images/user.png';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            color: AppColors.third,
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.storefront,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProducerPage(
                                userPk: userPk,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    // const VerticalDivider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProducerProfile(
                                token: widget.token,
                                userPk: userPk,
                              );
                            },
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                        maxRadius: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Align(
                      alignment: (messages[index]['user_pk'].toString() ==
                              account['user']['pk'].toString()
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index]['user_pk'].toString() ==
                                  account['user']['pk'].toString()
                              ? Colors.grey.shade200
                              : AppColors.third),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          messages[index]['message'] ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: messages[index]['user_pk'].toString() ==
                                    account['user']['pk'].toString()
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDefaults.margin),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Container(
                  //   // decoration: const BoxDecoration(
                  //   //   color: Color(0xFF0E3311),
                  //   // ),
                  //   padding: const EdgeInsets.all(0),
                  //   margin: const EdgeInsets.all(0),
                  //   // padding: const EdgeInsets.only(
                  //   //     left: 100, top: 0, right: 100, bottom: 0),
                  //   // color: Colors.transparent,
                  //   width: 150,
                  //   height: 40,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (context) => const ProducerProfileRate(),
                  //         ),
                  //       );
                  //     },
                  //     style: ButtonStyle(
                  //       padding: MaterialStateProperty.all<EdgeInsets>(
                  //           EdgeInsets.zero),
                  //     ),
                  //     child: const Text(
                  //       'Rate Producer',
                  //       style: TextStyle(fontSize: 12),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 30,
                        //     width: 30,
                        //     decoration: BoxDecoration(
                        //       color: Colors.lightBlue,
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: const Icon(
                        //       Icons.add,
                        //       color: Colors.white,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            sendChat();
                          },
                          backgroundColor: Colors.blue,
                          elevation: 0,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
