import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatMeassage extends StatefulWidget {
  const ChatMeassage({super.key});

  @override
  State<ChatMeassage> createState() => _ChatMeassageState();
}

class _ChatMeassageState extends State<ChatMeassage> {
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore
       .instance
       .collection('chat')
       .orderBy(
          'createdAt',
          descending: false,
       )
       .snapshots(), 
      builder: (ctx, Chatsnapshot) {
        if(Chatsnapshot.connectionState == ConnectionState.waiting){
          
          return const Center(
            child:CircularProgressIndicator(),
          );

        }

        if(!Chatsnapshot.hasData || (Chatsnapshot.data as QuerySnapshot).docs.isEmpty){
          return const Center(
            child: Text("No messages"),
          );
        }

        if(Chatsnapshot.hasError){
          return const Center(
            child: Text("something went wrong"),
          );
        }

        final loadedMessages = (Chatsnapshot.data as QuerySnapshot).docs;

        return ListView.builder(
           itemCount:  loadedMessages.length,
           itemBuilder: (context, index) {
            
              return Text((loadedMessages[index].data() as Map<String, dynamic>)['text']);
        },);


      },);
  }
}