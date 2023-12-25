import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/domen/model/user.dart';
import 'package:chat_app/domen/providers/firebase_provider.dart';
import 'package:chat_app/domen/service/notification_service.dart';
import 'package:chat_app/pages/chats_page/chat_field.dart';
import 'package:chat_app/pages/chats_page/chat_messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key, required this.userId});
  final String userId;
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final notificationsService = NotificationsService();
  @override
  void initState() {
    Provider.of<FireBaseProvider>(context , listen:false)..getUserbyId(widget.userId)..getMessage(widget.userId);
    notificationsService.firebaseNotification(context);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: Consumer<FireBaseProvider>(
          builder: (context, value, child) => value.user != null ?
           Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(value.user!.image == null ? 'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png' : value.user!.image!),
                radius: 20,
              ),
             const SizedBox(width: 20,),
              Text(
                value.user!.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ) : const SizedBox()
        ),
      ),
      body: Column(
        children: [
          ChatMessages(receiverId: widget.userId),
          ChatField(controller: controller,receiverId: widget.userId),
        ],
      ),
    );
  }
}
