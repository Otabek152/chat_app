import 'package:chat_app/domen/model/message.dart';
import 'package:chat_app/domen/providers/firebase_provider.dart';
import 'package:chat_app/pages/chats_page/message_buble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatelessWidget {
   ChatMessages({super.key , required this.receiverId});
   final String receiverId;
  final messages = [
    Message(senderId: "1", receiverId: "2",text: 'Hello', messageType: MessageType.text, readed: true, time: DateTime.now()),
    Message(senderId: "2", receiverId: "1",text: 'Hello back', messageType: MessageType.text, readed: true, time: DateTime.now()),

  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<FireBaseProvider>(
      builder: (context, value, child) => value.message.isEmpty ? const Expanded(child: Center(child: Text('Write something'),)) :
       Expanded(
         child: ListView.builder(
          controller: Provider.of<FireBaseProvider>(context,listen: false).scrollController,
          shrinkWrap: true,
          itemCount: value.message.length,
          itemBuilder: (context, index) {
            final isTextMessage = value.message[index].messageType != MessageType.text;
            final isMe = receiverId != value.message[index].senderId;
            return MessageBubble(message: value.message[index],isMe: isMe,isImage: isTextMessage,);
          },
               ),
       ),
    );
  }
}