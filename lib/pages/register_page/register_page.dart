import 'dart:typed_data';

import 'package:chat_app/components/mybutton.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/domen/providers/firebase/firebase_service.dart';
import 'package:chat_app/domen/service/firebase_storage_service.dart';
import 'package:chat_app/domen/service/media_service.dart';
import 'package:chat_app/domen/service/notification_service.dart';
import 'package:chat_app/pages/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:chat_app/pages/home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  static final notifications = NotificationsService();

  Uint8List? file;

  final FirebaseAuthServices _auth = FirebaseAuthServices();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUserUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    String name = nameController.text;
    String username = userNameController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    final image = await FirebaseStorageService.uploadImage(
        file!, 'image/profile/${user!.uid}');
    await FireBaseService.createUser(
      image: image,
      email: email,
      id: user.uid,
      name: name,
      username: username,
    );
    await notifications.requestPermission();
    await notifications.getToken();
    if (user != null) {
      print('User is created');
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(),
          ));
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final pickedImage = await MediaService.pickImage();
                    setState(() => file = pickedImage!);
                  },
                  child: file != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(file!),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 20,),
                const Text('Select Profile Image' , style: TextStyle(fontSize: 18 , color: Colors.black , fontWeight: FontWeight.bold),),
                const SizedBox(height: 50),
                MyTextField(
                  controller: emailController,
                  hintText: 'Write your email',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: nameController,
                  hintText: 'Write your name',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: userNameController,
                  hintText: 'Write your user name',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                //sign in button
                MyButton(
                  onTap: signUserUp,
                  text: 'Sign Up',
                ),
                const SizedBox(height: 20),

                // continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // not a memeber ? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
