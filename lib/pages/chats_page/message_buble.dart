import 'package:chat_app/domen/model/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key , required this.message , required this.isMe , required this.isImage});
  final Message message;
  final bool isMe;
  final bool isImage;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10 , right: 10,left: 10),
        padding: const EdgeInsets.all(10),
        decoration: isMe ?const BoxDecoration(
          borderRadius:  BorderRadius.only(topRight: Radius.circular(30) , bottomLeft: Radius.circular(30) , topLeft: Radius.circular(30)),
          color:  Colors.blue,
        ) : const BoxDecoration(
          borderRadius:  BorderRadius.only(topRight: Radius.circular(30) , bottomLeft: Radius.circular(30) , topLeft: Radius.circular(30)),
          color:  Colors.green,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            isImage ? Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15) , image: DecorationImage(image: NetworkImage(message.text))),
            ):
          Text(
           message.text,style: const TextStyle(color: Colors.white), 
          ),
          Text(message.time.toString() , style: const TextStyle(color: Colors.white , fontSize: 8),)
        ]),
      ),
    );
  }
}