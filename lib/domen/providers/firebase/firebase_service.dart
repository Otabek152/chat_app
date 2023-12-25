import 'dart:typed_data';

import 'package:chat_app/domen/model/message.dart';
import 'package:chat_app/domen/model/user.dart';
import 'package:chat_app/domen/service/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseService{
  static final firestore = FirebaseFirestore.instance;
  static Future<void> createUser({
    required String name,
    required String? image,
    required String email,
    required String id,
    required String username
  }) async {
    final user = UserModel(id: id, name: name, image: image, username: username , email: email);

    await firestore
        .collection('users')
        .doc(id)
        .set(user.toJson());
  }
  static Future<void> addTextMessage({required String content , required String receiverId}) async{
    final message = Message(senderId: FirebaseAuth.instance.currentUser!.uid, receiverId: receiverId, messageType: MessageType.text, readed: true, time: DateTime.now(), text: content);
    await _addMessageToChat(receiverId , message);
  }
  static Future<void> _addMessageToChat(String receiverId , Message message) async{
    await firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('chat').doc(receiverId).collection('message').add(message.toJson());
    await firestore.collection('users').doc(receiverId).collection('chat').doc(FirebaseAuth.instance.currentUser!.uid).collection('message').add(message.toJson());
  }
  static Future<void> addImageMessage({required String receiverId , required Uint8List file})async{
    final image = await FirebaseStorageService.uploadImage(file, 'image/chat/${DateTime.now()}');
    final message = Message(senderId: FirebaseAuth.instance.currentUser!.uid, receiverId: receiverId, messageType: MessageType.image, readed: true, time: DateTime.now(), text: image);
    await _addMessageToChat(receiverId, message);
  }
}