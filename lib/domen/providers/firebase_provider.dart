import 'package:chat_app/domen/model/message.dart';
import 'package:chat_app/domen/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireBaseProvider extends ChangeNotifier{
  List<UserModel> users = [];
  UserModel? user;
  List<Message> message = [];
  ScrollController scrollController = ScrollController();
  List<UserModel> getAllUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
          this.users = user.docs
            .map((e) => UserModel.fromJson(e.data())).toList();
              notifyListeners();
        });
        return users;
  }
  UserModel? getUserbyId(String userId){
    FirebaseFirestore.instance.collection('users').doc(userId).snapshots(includeMetadataChanges: true).listen((event) {this.user = UserModel.fromJson(event.data()!);notifyListeners();});
    return user;
  }

  List<Message> getMessage(String receiverId) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('chat').doc(receiverId).collection('message').orderBy('time' , descending: false).snapshots(includeMetadataChanges: true).listen((event) {this.message = event.docs.map((e) => Message.fromJson(e.data())).toList();notifyListeners();scrollDown();});
    return message;
  }
    void scrollDown() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
              scrollController.position.maxScrollExtent);
        }
      });
}