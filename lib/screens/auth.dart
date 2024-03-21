import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase=FirebaseAuth.instance;
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AutnScreenState();
}

class _AutnScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _islogin= true;

  var _enterdmail="";
  var _enterdpasscode=""; 

  void _isSubmit() async{
    final isValid = _form.currentState!.validate();

    if(!isValid){
      return;
      }
      _form.currentState!.save();
      
    try {
      if(_islogin){
       final userCredential = await _firebase.signInWithEmailAndPassword(email: _enterdmail, password: _enterdpasscode);
       print(userCredential);
      } else{
         final userCredential= await _firebase.createUserWithEmailAndPassword(email: _enterdmail, password: _enterdpasscode);
          
      }
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(e.message??" Auth failed")));

          
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

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer
                          ),
                          onPressed: 
                          () => _isSubmit(), 
                          child: 
                           Text(_islogin ? "Login" : "SignUp")
                        ),
                        
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