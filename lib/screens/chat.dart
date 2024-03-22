import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chat_message.dart';
import 'package:flutter_chat/widgets/new_meassages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text("Fluttter Chat"),
        actions: [
          IconButton(
            onPressed:() {
              FirebaseAuth.instance.signOut();
            }, 
            icon:  Icon(Icons.exit_to_app, 
              color: Theme.of(context).colorScheme.primary,
            )
          )
        ],
        centerTitle: true,

      ),
      body:const  Center(
        child: Column(children: [
          Expanded(child:
           ChatMeassage()
          ),

          NewMesssages(),
        ],),
      ),
    );
  }
}