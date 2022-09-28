import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/models/chat_message.dart';

class Moderator extends StatefulWidget {
  const Moderator({Key? key}) : super(key: key);

  @override
  State<Moderator> createState() => _ModeratorState();
}

class _ModeratorState extends State<Moderator> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;

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
    _firstAutoscrollExecuted = true;

    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _shouldAutoscroll = true;
    } else {
      _shouldAutoscroll = false;
    }
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
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Chat Support',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Stack(
            //       children: [
            //         Positioned(
            //           left: 0,
            //           child: IconButton(
            //             onPressed: () {
            //               Navigator.pop(context);
            //             },
            //             icon: const Icon(
            //               Icons.arrow_back,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     // const Text(
            //     //   "Chat Support",
            //     //   style: TextStyle(
            //     //       fontSize: 16,
            //     //       fontWeight: FontWeight.w600,
            //     //       color: Colors.white),
            //     // ),
            //   ],
            // ),
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
