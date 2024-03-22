import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat/screens/chat.dart';
import 'package:flutter_chat/screens/splashScreen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 63, 17, 177)),

      ),
      home:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges() ,
        builder: (context, snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting){
            return const splashScreen();
          }
          if(snapshot.hasData){
            return const  ChatScreen();
          }
          return const  AuthScreen();
        } ,)
    );
  }
}

