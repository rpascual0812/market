import 'package:flutter/material.dart';
import 'package:market/constants/index.dart';
import 'package:market/models/chat_message.dart';
import 'package:market/screens/producer/producer_profile/producer_profile.dart';
import 'package:market/screens/producer/producer_page/producer_page.dart';

class Bubble extends StatefulWidget {
  const Bubble({Key? key}) : super(key: key);

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // bool _firstAutoscrollExecuted = false;
  // bool _shouldAutoscroll = false;

  List<ChatMessage> messages = [
    ChatMessage(pk: 1, messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(
        pk: 2, messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        pk: 3,
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(
        pk: 4, messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        pk: 5,
        messageContent: "Is there any thing wrong?",
        messageType: "sender"),
    ChatMessage(pk: 1, messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(
        pk: 2, messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        pk: 3,
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(
        pk: 4, messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        pk: 5,
        messageContent: "Is there any thing wrong?",
        messageType: "sender"),
  ];

  void _scrollToBottom() {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void sendChat() {
    setState(() {
      messages.insert(
        messages.length,
        ChatMessage(
          pk: messages.length + 1,
          messageContent: messageController.text,
          messageType: "sender",
        ),
      );

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

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  "Kriss Benwat",
                  style: TextStyle(
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
                              return const ProducerPage();
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
                              return const ProducerProfile();
                            },
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundImage:
                            NetworkImage("https://i.imgur.com/vavfJqu.gif"),
                        maxRadius: 20,
                        // size: 25,
                      ),
                    ),
                  ],
                ),
                // IconButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   icon: const Icon(
                //     Icons.arrow_back,
                //     color: Colors.black,
                //   ),
                // ),
                // const SizedBox(
                //   width: 2,
                // ),
                // const CircleAvatar(
                //   backgroundImage:
                //       NetworkImage("https://i.imgur.com/vavfJqu.gif"),
                //   maxRadius: 20,
                // ),
                // const SizedBox(
                //   width: 12,
                // ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       const Text(
                //         "Kriss Benwat",
                //         style: TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.w600),
                //       ),
                //       const SizedBox(
                //         height: 6,
                //       ),
                //       Text(
                //         "Online",
                //         style: TextStyle(
                //             color: Colors.grey.shade600, fontSize: 13),
                //       ),
                //     ],
                //   ),
                // ),
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
                      alignment: (messages[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : AppColors.third),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          messages[index].messageContent,
                          style: TextStyle(
                            fontSize: 15,
                            color: messages[index].messageType == "receiver"
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
