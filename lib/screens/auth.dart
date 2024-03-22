import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/user_image_picker.dart';

final _firebase=FirebaseAuth.instance;
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AutnScreenState();
}

class _AutnScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _islogin= true;

  var _enterdmail ="";
  var _enterdpasscode =""; 
  File? _selectedImage;
  var _isAuthenticating   = false;
  var _enteredUsername = "";

  void _isSubmit() async{
    final isValid = _form.currentState!.validate();

    if(!isValid){
      return;
      }

      if(!isValid ||!_islogin && _selectedImage == null){
        return;
      }



      _form.currentState!.save();
      
    try {
       setState(() {
         _isAuthenticating = true;
       });
      if(_islogin){
       final userCredential = await _firebase.signInWithEmailAndPassword(email: _enterdmail, password: _enterdpasscode);
       
      } else{
         final userCredential= await _firebase.createUserWithEmailAndPassword(email: _enterdmail, password: _enterdpasscode);

         final storageRef = FirebaseStorage.instance
              .ref()
              .child("USER_IMAGE")
              .child("${userCredential.user!.uid}.jpg");

         await storageRef.putFile(_selectedImage!);

         final imageUrl = await storageRef.getDownloadURL();
         
         await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
                'user' : _enteredUsername,
                'email': _enterdmail,
                'image_url': imageUrl,
                'passcode' : _enterdpasscode,
              });
         
      }
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message??" Auth failed")));

          setState(() {
            _isAuthenticating = false; 
          });

          
        }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                 top: 30,
                 bottom:20,
                 left:20,
                 right:30,
                ),
                width: 200,
                child: Image.asset("assets/chat.png"),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                     child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(!_islogin) UserImagePicker(
                          onpickimage: ((pickedImage) {
                            _selectedImage=pickedImage;

                        }),), 
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email address'

                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,

                          validator: (value) {
                            if(value==null||value.trim().isEmpty|| !value.contains('@')){
                              return "please enter correct email";
                            }
                          },
                          onSaved: (newValue) {
                            _enterdmail=newValue!; 
                          },
                        ),

                        if(!_islogin)

                        TextFormField(
                          decoration: const InputDecoration(
                          labelText: 'username',
                          ),
                          enableSuggestions: false,

                          validator:(value){
                            if(value==null|| value.isEmpty|| value.trim().length<4){
                              return 'please enter at least 4 character';
                            }
                          },
                          onSaved: (newValue) {
                            _enteredUsername = newValue!;
                          },

                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Passcode'

                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          obscureText: true,
                        
                          validator: (value) {
                            if(value==null||value.trim().isEmpty){
                              return  "valid passcode";
                            }
                            else if(value.trim().length<8){
                              return "passcode must contains 8 alphabet";
                            }

                            return null;
                          },

                          onSaved: (value) {
                            _enterdpasscode =value!;

                          } ,
                        
                        ),
                        const SizedBox(height: 12,),

                        if(_isAuthenticating)
                        const CircularProgressIndicator(),
                        
                        if (!_isAuthenticating)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer
                          ),
                          onPressed: 
                          () => _isSubmit(), 
                          child: 
                           Text(_islogin ? "Login" : "SignUp")
                        ),
                        if(!_isAuthenticating) 
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _islogin=!_islogin;
                            });
                            
                          },
                          child: Text(_islogin ?"Create an account" : "I already have an account.  Login. "))
                      ],
                     ) 
                    ),
                  ),
                  
                ),
              )
            ],
          ),
        ) ),
    );
  }
}