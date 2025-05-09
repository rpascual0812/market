import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/chat/bubble.dart';
import 'package:time_elapsed/time_elapsed.dart';

class ConversationList extends StatefulWidget {
  const ConversationList({
    super.key,
    required this.token,
    required this.account,
    required this.chat,
  });

  final String token;
  final Map<String, dynamic> account;
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

  void changedChatStatus(status) {
    setState(() {
      widget.chat['read'] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.chat['chat_participants'].length);
    // print(widget.chat['chat_participants']);
    var image = widget.chat.isNotEmpty &&
            widget.chat['chat_participants'].length > 0
        ? '${dotenv.get('API')}/${widget.chat['chat_participants'][0]['user']['user_document']['document']['path']}'
        : '';
    var name = widget.chat.isNotEmpty &&
            widget.chat['chat_participants'].length > 0
        ? '${widget.chat['chat_participants'][0]['user']['first_name']} ${widget.chat['chat_participants'][0]['user']['last_name']}'
        : '';
    var date = TimeElapsed.fromDateStr(widget.chat['last_message_date']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Bubble(
                  userPk: widget.chat['chat_participants'][0]['user']['pk']
                      .toString(),
                  token: widget.token,
                  callback: (status) {
                    changedChatStatus(status);
                  });
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
                            style: TextStyle(
                                fontSize: AppDefaults.fontSize + 1,
                                fontWeight: widget.chat['read']
                                    ? FontWeight.normal
                                    : FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.chat['last_message'] ?? '',
                            style: TextStyle(
                                fontSize: AppDefaults.fontSize - 1,
                                // color: Colors.grey.shade600,
                                fontWeight: widget.chat['read']
                                    ? FontWeight.normal
                                    : FontWeight.bold),
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
              style: TextStyle(
                fontSize: AppDefaults.fontSize - 2,
                fontWeight:
                    widget.chat['read'] ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
