import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:market/components/network_image.dart';
import 'package:market/constants/index.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:http/http.dart' as http;
import 'package:market/screens/profile/components/complaint_view_image.dart';

class ComplaintBubble extends StatefulWidget {
  const ComplaintBubble({
    super.key,
    required this.complaint,
    required this.token,
  });

  final Map<String, dynamic> complaint;
  final String token;

  @override
  State<ComplaintBubble> createState() => _ComplaintBubbleState();
}

class _ComplaintBubbleState extends State<ComplaintBubble> {
  final clientOptions = ably.ClientOptions(key: dotenv.get('ABLY_KEY'));

  var complaintPk = '';
  String image = '';
  String name = '';

  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // bool _firstAutoscrollExecuted = false;
  // bool _shouldAutoscroll = false;
  Map<String, dynamic> account = {};
  Map<String, dynamic> chat = {};
  List messages = [];

  int skip = 0;
  int take = 10;

  @override
  void initState() {
    super.initState();
    complaintPk = widget.complaint['pk'].toString();

    var token = AppDefaults.jwtDecode(widget.token);
    fetchAccount(token['sub']);
    _scrollController.addListener(_scrollListener);

    initAbly();
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
          fetchMessages();
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
      final url = Uri.parse(
              '${dotenv.get('API')}/complaints/${widget.complaint['pk']}/messages')
          .replace(queryParameters: params);
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.get(url, headers: headers);
      log(res.statusCode.toString());
      if (res.statusCode == 200) {
        setState(() {
          var data = json.decode(res.body);
          // print('messages ${data['data']}');
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
    final channelId = 'complaint-${widget.complaint['pk'].toString()}';
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
    // print('initAbly $complaintPk');
    ably.RealtimeChannel channel = realtime.channels.get(channelId);
    channel.on().listen((ably.ChannelStateChange stateChange) async {
      // Handle channel state change events
      // print('RealtimeChannel');
      // AppDefaults.toast(context, 'success', 'RealtimeChannel');
    });

    StreamSubscription<ably.Message> subscription =
        channel.subscribe(name: channelId).listen((ably.Message message) {
      // Handle channel messages with name 'event1'
      print(message.data);

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

        setState(() {
          messages.insert(messages.length, newMessage);
        });
        _scrollToBottom();
      }
    });
  }

  void sendChat() async {
    final channelId = 'complaint-${widget.complaint['pk'].toString()}';

    if (messageController.text != '') {
      try {
        var body = {
          'pk': widget.complaint['pk'].toString(),
          'uuid': channelId,
          'message': messageController.text,
          'user_pk': account['user']['pk'].toString(),
        };

        // print(widget.token);
        // print(widget.userPk.toString());
        final url = Uri.parse(
            '${dotenv.get('API')}/complaints/${widget.complaint['pk']}/messages');
        final headers = {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
        };

        var res = await http.post(url, headers: headers, body: body);
        if (res.statusCode == 201) {
          var body = json.decode(res.body);

          var ablyData = {
            'pk': body['data']['pk'].toString(),
            'uuid': 'complaint-${widget.complaint['pk'].toString()}',
            'length': (messages.length + 1).toString(),
            'message': messageController.text,
            'user_pk': account['user']['pk'].toString(),
          };

          ably.Realtime realtime = ably.Realtime(options: clientOptions);
          // ably.RealtimeChannel conversationChannel =
          //     realtime.channels.get(channelId);
          // await conversationChannel.publish(
          //   name: channelId,
          //   data: ablyData,
          // );

          ably.RealtimeChannel complaintbubbleChannel =
              realtime.channels.get(channelId);
          await complaintbubbleChannel.publish(
            name: channelId,
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
    if (chat.isNotEmpty) {
      var found = false;
      for (var i = 0; i < chat['chat_participants'].length; i++) {
        if (chat['chat_participants'][i]['user']['pk'] !=
            account['user']['pk']) {
          found = true;
          image = chat['chat_participants'] != null
              ? '${chat['chat_participants'][i]['user']['user_document']['document']['path']}'
              : '';
          name = chat['chat_participants'] != null
              ? '${chat['chat_participants'][i]['user']['first_name']} ${chat['chat_participants'][i]['user']['last_name']}'
              : '';
        }
      }

      if (!found) {
        image = chat['chat_participants'] != null
            ? '${chat['chat_participants'][0]['user']['user_document']['document']['path']}'
            : '';
        name = chat['chat_participants'] != null
            ? '${chat['chat_participants'][0]['user']['first_name']} ${chat['chat_participants'][0]['user']['last_name']}'
            : '';
      }
    }

    image = image != '' ? image : '${dotenv.get('S3')}/images/user.png';

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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  widget.complaint['subject'],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
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
            Visibility(
              visible: widget.complaint['complaint_document'].isNotEmpty
                  ? true
                  : false,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: List.generate(
                      widget.complaint['complaint_document'].length,
                      (index) {
                        return InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ComplaintViewImage(
                                    document:
                                        widget.complaint['complaint_document']
                                            [index]['document'],
                                  ),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5, bottom: 5),
                            height: 75,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: NetworkImageWithLoader(
                                  '${widget.complaint['complaint_document'][index]['document']['path']}',
                                  false),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
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
                        child: Html(data: messages[index]['message'] ?? ''),
                        // child: Text(
                        //   messages[index]['message'] ?? '',
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //     color: messages[index]['user_pk'].toString() ==
                        //             account['user']['pk'].toString()
                        //         ? Colors.black
                        //         : Colors.white,
                        //   ),
                        // ),
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
