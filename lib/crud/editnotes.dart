
import 'dart:io';
import 'dart:math';

import 'package:appnote/component/alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditNotes extends StatefulWidget {
  final docid;
  final list;
  const EditNotes({Key? key , this.docid , this.list}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {

  CollectionReference notesref = FirebaseFirestore.instance.collection("reclamation");

  late Reference ref;

    late File file;
  var title, note, imageurl;


  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  editNotes(context) async {
    var formdata = formstate.currentState;


    if (formdata!.validate()) {
      showLoading(context);
      formdata.save();
      await ref.putFile(file);
      imageurl = await ref.getDownloadURL();
      await notesref.doc(widget.docid).update({
        "type_reclamation": title,
        "reclamation": note,
        "imageurl": imageurl,
      }).then((value) {
        Navigator.of(context).pushNamed("homepage");
      }).catchError((e) {
        print("$e");
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC2E0E3),
      appBar: AppBar(title: const Text("Modifier Reclamation"),),
      body: Container(child: Column(children: [
        Form(key: formstate,
            child: Column(children: [
              TextFormField(
                initialValue: widget.list['type_reclamation'],
                validator: (value) {
                  if (value == null) {
                    return "";
                  }
                  if (value.length > 30) {
                    return "type de reclamation ne peut pas dépasser 30 lettres ";
                  }
                  if (value.length < 2) {
                    return "type de reclamation ne peut pas être moins de deux lettres ";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  title = newValue;
                },
                maxLength: 30,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Type de Reclamation",
                    prefixIcon: Icon(Icons.note)),),
              TextFormField(
                initialValue: widget.list['reclamation'],
                validator: (value) {
                  if (value == null) {
                    return "";
                  }
                  if (value.length > 255) {
                    return "la reclamation ne peut pas dépasser 255 lettres ";
                  }
                  if (value.length < 10) {
                    return "la reclamation ne peut pas être moins de 10 lettres ";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  note = newValue;
                },
                minLines: 1,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Reclamation",
                    prefixIcon: Icon(Icons.note)),),
              ElevatedButton(onPressed: () {
                showBottomSheet(context);
              }, child: const Text("Modifier Document pour la Reclamation")),
              ElevatedButton(
                onPressed: ()async {await editNotes(context);}, child: const Text("Modifier Reclamation"),),
            ],))
      ]),),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: 170,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start
            , children: [
          const Text(" Edit Image",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          InkWell(
            onTap: () async {
              var picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery);
              if (picked != null) {
                file = File(picked.path);
                var rand = Random().nextInt(1000000);
                //pour que le nom etre unique
                var imagename = "$rand" + basename(picked.path);

                ref = await FirebaseStorage.instance
                    .ref("images").child("$imagename");
                Navigator.of(context).pop();
              }
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Row(children: [
                  Icon(Icons.photo_outlined, size: 20),
                  SizedBox(width: 20),
                  Text("From Gallery", style: TextStyle(fontSize: 20),)],)),
          ),
          InkWell(
            onTap: () async {
              var picked = await ImagePicker().pickImage(
                  source: ImageSource.camera);
              if (picked != null) {
                file = File(picked.path);
                var rand = Random().nextInt(1000000);
                //pour que le nom etre unique
                var imagename = "$rand" + basename(picked.path);

                ref = await FirebaseStorage.instance
                    .ref("images").child("$imagename");
                Navigator.of(context).pop();

              }
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Row(children: [
                  Icon(Icons.camera, size: 20),
                  SizedBox(width: 20),
                  Text("From Camera", style: TextStyle(fontSize: 20),)],)),
          ),
        ]),
      );
    },);
  }





}