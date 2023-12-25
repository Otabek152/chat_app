import 'package:chat_app/domen/model/user.dart';
import 'package:chat_app/domen/providers/firebase_provider.dart';
import 'package:chat_app/pages/home_page/user_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Provider.of<FireBaseProvider>(context , listen: false).getAllUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Consumer<FireBaseProvider>(
      builder: (context, value, child) {
        return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) =>
          value.users[index].id != FirebaseAuth.instance.currentUser?.uid ? 
         UserItem(user: value.users[index],) : const SizedBox(), 
      
      physics:const BouncingScrollPhysics(),
      separatorBuilder: (context, index) =>const SizedBox(height: 15,),
      itemCount: value.users.length,);
      },
    );
  }
}
