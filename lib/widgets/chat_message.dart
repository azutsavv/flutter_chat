import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/bubble_messgae.dart';

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
          descending: true,
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
          padding: const EdgeInsets.only(
            bottom: 40,
            right: 13,
            left: 13,
          ),
          reverse: true,
           itemCount:  loadedMessages.length,
           itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nextchatMessage = index+1< loadedMessages.length
               ? loadedMessages[index+1].data()
               : null ;
            final currentMessageUserID = (chatMessage as Map<String, dynamic>)['userId'];
            final nextMessageUserID = nextchatMessage != null ?(nextchatMessage as Map)['userId']:null;
            final nextUserIsSame = nextMessageUserID ==currentMessageUserID ;

            if(nextUserIsSame){
              return MessageBubble.next(
                message:chatMessage['text'], 
                isMe: authenticatedUser.uid ==currentMessageUserID);
            }else{
              return MessageBubble.first(
                userImage: chatMessage['userImage'], 
                username: chatMessage['username'], 
                message: chatMessage['text'], 
                isMe: authenticatedUser.uid== currentMessageUserID);
            }
        },);


      },);
  }
}