import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewMesssages extends StatefulWidget {
  const NewMesssages({super.key});

  @override
  State<NewMesssages> createState() => _NewMesssagesState();
}

class _NewMesssagesState extends State<NewMesssages> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  
  void _submitMessage()async{
    final enteredMessage = _messageController.text;

    if(enteredMessage.trim().isEmpty){
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user =FirebaseAuth.instance.currentUser!;
    
    final userData = await FirebaseFirestore.instance
     .collection('users')
     .doc(user.uid)
     .get();

    FirebaseFirestore.instance
     .collection("chat")
     .add({
      'text':enteredMessage,
      'createdAt':Timestamp.now(),
      'userId':user.uid,
      'username':userData.data()!['user'],
      'userImage':userData.data()!['image_url'],

     });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding:const EdgeInsets.only(
      left: 15,
      right: 1,
      bottom: 14,
    ),
    child: Row(
      children: [
        Expanded(
          child:
          TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences ,
            autocorrect: true,
            enableSuggestions: true,
            decoration:const  InputDecoration(
              labelText: "send a message" 
            ),
          ), 
        ),
      IconButton(
        onPressed: _submitMessage,
        color: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.send_outlined))
      ],
    ),
    );
  }
}