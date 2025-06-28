import 'package:appnote/component/alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var myusername, mypassword, myemail;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myemail,
          password: mypassword,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            body: const Center(
              child: Text(
                'Le mot de passe est trop court',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            title: 'Error',
          ).show();
          // AwesomeDialog(context:context ,title:"Error" ,body:Text("Password is too week") )..show();
          // print("weak-password");
        } else if (e.code == 'email-already-in-use') {
          //navigator pour eleminer CircularProgressIndicatorde de showloading
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            body: const Center(
              child: Text(
                'email déjà utilisé',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            title: 'Error',
          ).show();
          // AwesomeDialog(context:context ,title:"Error" ,body:Text("email-already-in-use") )..show();
          //print("email-already-in-use");
        }
      } catch (e) {
        print(e);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC2E0E3),
      body: ListView(children: [
        SizedBox(height: 100),
        Center(child: Image.asset("images/logoreclami.png")),
        Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formstate,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (val) {
                        myusername = val;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "";
                        }
                        if (value.length > 100) {
                          return "username ne peut pas dépasser 100 lettres ";
                        }
                        if (value.length < 2) {
                          return "username ne peut pas être moins de deux lettres  ";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onSaved: (val) {
                        myemail = val;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "";
                        }
                        if (value.length > 100) {
                          return "email ne peut pas dépasser 100 lettres ";
                        }
                        if (value.length < 2) {
                          return "email ne peut pas être moins de deux lettres  ";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onSaved: (val) {
                        mypassword = val;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "";
                        }
                        if (value.length > 100) {
                          return "mot de passe ne peut pas dépasser 100 lettres";
                        }
                        if (value.length < 4) {
                          return "mot de passe ne peut pas être moins de quatre lettres ";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text("Si vous avez un compte"),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("login");
                              },
                              child: Text(
                                "Cliquez ici",
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          var response = await signUp();
                          if (response != null) {
                            FirebaseFirestore.instance.collection("users").add(
                                {"username": myusername, "email": myemail});
                            Navigator.of(context)
                                .pushReplacementNamed("homepage");
                          } else {
                            print("signup failed");
                          }
                        },
                        child: const Text(
                          "SingnUp",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                )))
      ]),
    );
  }
}
