import 'package:flutter/material.dart';
import 'package:market/screens/chat/conversation_list.dart';
import 'package:market/models/chat_user.dart';

import 'package:market/models/order.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
      name: "Jane Russel",
      messageText: "Awesome Setup",
      imageURL: "https://i.imgur.com/vavfJqu.gif",
      time: "Now",
    ),
    ChatUsers(
      name: "Glady's Murphy",
      messageText: "That's Great",
      imageURL: "https://i.imgur.com/jG0jrjW.gif",
      time: "Yesterday",
    ),
    ChatUsers(
      name: "Jorge Henry",
      messageText: "Hey where are you?",
      imageURL: "https://i.imgur.com/VocmKXJ.gif",
      time: "31 Mar",
    ),
    ChatUsers(
      name: "Philip Fox",
      messageText: "Busy! Call me in 20 mins",
      imageURL: "https://i.imgur.com/F1oP4Zh.gif",
      time: "28 Mar",
    ),
    ChatUsers(
      name: "Debra Hawkins",
      messageText: "Thankyou, It's awesome",
      imageURL: "https://i.imgur.com/D8hOYEu.gif",
      time: "23 Mar",
    ),
    ChatUsers(
      name: "Jacob Pena",
      messageText: "will update you in evening",
      imageURL: "https://i.imgur.com/BLz5n08.gif",
      time: "17 Mar",
    ),
    ChatUsers(
      name: "Andrey Jones",
      messageText: "Can you please share the file?",
      imageURL: "https://i.imgur.com/NZ7URdO.gif",
      time: "24 Feb",
    ),
    ChatUsers(
      name: "John Wick",
      messageText: "How are you?",
      imageURL: "https://i.imgur.com/BHTKXid.gif",
      time: "18 Feb",
    ),
  ];

  var filterValue = 'Show All';
  var filters = ['Show All', 'Show only unread', 'Mark all as read'];

  late List<Order> orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    DropdownButton(
                      value: filterValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: filters.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          filterValue = newValue!;
                        });
                      },
                    ),
                    // Container(
                    //   padding: const EdgeInsets.only(
                    //       left: 8, right: 8, top: 2, bottom: 2),
                    //   height: 30,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     color: AppColors.primary,
                    //   ),
                    //   child: Row(
                    //     children: const <Widget>[
                    //       Icon(
                    //         Icons.add,
                    //         color: Colors.white,
                    //         size: 20,
                    //       ),
                    //       SizedBox(
                    //         width: 2,
                    //       ),
                    //       Text(
                    //         "Add New",
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
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
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
