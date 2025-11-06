import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bot.dart';
import 'home.dart';

class loginfb extends StatefulWidget {
  const loginfb({super.key});

  @override
  State<loginfb> createState() => _loginfbState();
}

class _loginfbState extends State<loginfb> {
  final _krishna =GlobalKey<FormState>();

  bool show =false;
  bool showw =false;

 TextEditingController email=TextEditingController();
 TextEditingController password=TextEditingController();

 Sce() {
   setState(() {
     email.text.isNotEmpty && password.text.isNotEmpty ? show = true : showw = false;
   });
 }

  create()async{
   await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: email.text,
       password:  password.text);
   Navigator.push(context, MaterialPageRoute(builder: (context)=>CRDScreen()));
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("login successfully")));
  }
  final GoogleSignIn  googleSignIn = GoogleSignIn(
    clientId:
    '440615955255-ru2rjh9jc8gl06t2tq43clns48p467el.apps.googleusercontent.com',
  );

  Future<User?> signInWithGoogle(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }
      final user = userCredential.user;
      if (user != null) {
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
      ),
      body:Form(
        key: _krishna,
          child:  Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller:email,
                    decoration: InputDecoration(
                      hintText: "Enter the email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (Input) {
                      if (Input!.isEmpty || Input == Null! || Input.length < 2) {
                        return"please enter the valid email";
                      }
                      return null;
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: password,
                    obscureText: !showw,
                    onChanged: (i){
                      Sce();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showw= !showw;
                            });
                          },
                          icon: Icon(showw ? Icons.visibility : Icons.visibility_off)),
                      hintText: "ENTER YOUR PASSWORD",
                      border: OutlineInputBorder(),
                    ),
                    validator:(input){
                      if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(input!))
                      {
                        return "pleace enter the valid password";
                      }
                      return null;
                    }
                ),
              ),
              ElevatedButton(onPressed: (){
                    if(_krishna.currentState!.validate())
                      create();
              }, child: Text("LOGIN")),
              ElevatedButton(onPressed:(){
                signInWithGoogle(context);
              } , child: Text("google"))
            ],
          )
      )
    );
  }
}
