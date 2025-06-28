

import 'package:appnote/component/alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}



class _LoginState extends State<Login> {

  var mypassword,myemail;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signIn()async{
    var formdata = formstate.currentState;
    if(formdata!.validate()){
      formdata.save();
      try {
        showLoading(context);
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: myemail,
            password: mypassword
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            body: const Center(child: Text(
              'Aucun utilisateur trouvé pour ce email.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Error',
          ).show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            body: const Center(child: Text(
              'Incorrect mot de passe fourni pour cet utilisateur.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Error',
          ).show();
        }
      }
    }else{print("not Valid");}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC2E0E3),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(margin: const EdgeInsets.all(10),
                child: Image.asset("images/steglogin.jpg")),

            Center(
              child: Container(
                child: Image.asset("images/logoreclami.png"),

              ),
            ),

            Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: formstate,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (val) {
                            myemail = val;
                          },
                          validator: (value) {
                            if(value==null){return"";}
                            if(value.length >100){return"email ne peut pas dépasser 100 lettres";}
                            if(value.length <2){return"email ne peut pas être moins de deux lettres ";}
                            return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: "Email",
                              border:
                              OutlineInputBorder(borderSide: BorderSide(width: 1))),
                        ),
                        const SizedBox(height: 20),


                        TextFormField(
                          onSaved: (val) {
                            mypassword = val;
                          },
                          validator: (value) {
                            if(value==null){return"";}
                            if(value.length >100){return"mot de passe ne peut pas dépasser 100 lettres ";}
                            if(value.length <4){return"mot de passe ne peut pas être moins de quatre lettres ";}
                            return null;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              hintText: "Password",
                              border:
                              OutlineInputBorder(borderSide: BorderSide(width: 1))),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Text("Créer un Compte? "),
                              InkWell(
                                  onTap: (){Navigator.of(context).pushReplacementNamed("signup");}
                                  ,child: const Text("Cliquez ici",style: TextStyle(color: Colors.blue),))
                            ],
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: ()async {
                              var user = await signIn();
                              if (user != null){
                                Navigator.of(context).pushReplacementNamed("homepage");}
                            },
                            child: const Text(
                              "SingnIn",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),

                      ],
                    )))
          ]),
    );
  }
}