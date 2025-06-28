
import 'package:appnote/auth/login.dart';
import 'package:appnote/auth/signup.dart';
import 'package:appnote/crud/addnotes.dart';
import 'package:appnote/crud/viewnotes.dart';
import 'package:appnote/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

 bool islogin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if(user==null){
    islogin =false;
  }else{islogin=true;}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: islogin == false ? Login(): HomePage(),
      theme: ThemeData(
          primaryColor: Colors.red,
          textTheme: TextTheme()
      ),
      routes: {
        "login" : (context) => Login(),
        "signup" : (context) => Signup(),
        "homepage" : (context) => HomePage(),
        "addnotes" : (context) => AddNotes(),


      },
    );
  }


}