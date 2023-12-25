import 'dart:typed_data';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/domen/providers/firebase/firebase_service.dart';
import 'package:chat_app/domen/service/media_service.dart';
import 'package:chat_app/domen/service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatField extends StatefulWidget {
  ChatField({super.key, required this.controller, required this.receiverId});
  var controller = TextEditingController();
  final String receiverId;

  @override
  State<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  final recorder = FlutterSoundRecorder();
  final notificationsService = NotificationsService();

  bool isrecording = false;
  Uint8List? file;
  Uint8List? voicefile;
  @override
  void initState() {
    notificationsService.getReceiverToken(widget.receiverId);
    initRecored();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  Future initRecored() async{
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw 'Not Permited for recording';
    }

    await recorder.openRecorder();

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }
  Future record() async{
    await recorder.startRecorder(toFile: 'audio');

  }
  Future stop() async{
    await recorder.stopRecorder();

  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: MyTextField(
              controller: widget.controller,
              hintText: 'Write your message',
              obscureText: false),
        ),
        IconButton(
            onPressed: () => _sendText(context), icon: const Icon(Icons.send)),
        GestureDetector(onLongPress: () async=> await record() ,onLongPressEnd: (details) async=> await stop(), child: const Icon(Icons.voice_chat)),
        IconButton(
            onPressed: () => _sendImage(), icon: const Icon(Icons.photo)),
      ],
    );
  }

  Future<void> _sendText(BuildContext context) async {
    await notificationsService.sendNotification(body: widget.controller.text, senderId: FirebaseAuth.instance.currentUser!.uid);
    if (widget.controller.text.isNotEmpty) {
      await FireBaseService.addTextMessage(
          content: widget.controller.text, receiverId: widget.receiverId);
      widget.controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _sendImage() async {
    await notificationsService.sendNotification(body: 'image . . . . . ', senderId: FirebaseAuth.instance.currentUser!.uid);

    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FireBaseService.addImageMessage(receiverId : widget.receiverId , file:file!);
    }
  }

  Future<void> _sendVoice() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => voicefile = pickedImage);
    if (file != null) {
      await FireBaseService.addImageMessage(receiverId : widget.receiverId , file:file!);
    }
  }
}
