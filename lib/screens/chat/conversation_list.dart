import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/index.dart';
import 'package:market/screens/chat/bubble.dart';
import 'package:time_elapsed/time_elapsed.dart';

class ConversationList extends StatefulWidget {
  const ConversationList({
    Key? key,
    required this.token,
    required this.account,
    required this.chat,
  }) : super(key: key);

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

    var read = widget.chat['read'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              print('${widget.chat['pk']} $read');
              return Bubble(
                userPk: widget.chat['chat_participants'][0]['user']['pk']
                    .toString(),
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
                            style: TextStyle(
                                fontSize: AppDefaults.fontSize + 1,
                                fontWeight:
                                    read ? FontWeight.normal : FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.chat['last_message'] ?? '',
                            style: TextStyle(
                                fontSize: AppDefaults.fontSize - 1,
                                // color: Colors.grey.shade600,
                                fontWeight:
                                    read ? FontWeight.normal : FontWeight.bold),
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
                fontWeight: read ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
