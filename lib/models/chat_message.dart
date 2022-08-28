import 'package:flutter/cupertino.dart';

class ChatMessage {
  int pk;
  String messageContent;
  String messageType;
  ChatMessage({
    required this.pk,
    required this.messageContent,
    required this.messageType,
  });
}
