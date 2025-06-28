import 'package:appnote/crud/editnotes.dart';
import 'package:appnote/crud/viewnotes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesref =
      FirebaseFirestore.instance.collection("reclamation");
  getUser() {
    var user = FirebaseAuth.instance.currentUser;

    print(user?.email);
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffC2E0E3),
        appBar: AppBar(
          title: Text("Home Page"),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed("login");
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addnotes");
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          child: FutureBuilder(
              future: notesref
                  .where("userid",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          onDismissed: (direction) async {
                            //effacer la reclamation
                            await notesref
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                            //effacer l'image from firestorage
                            await FirebaseStorage.instance
                                .refFromURL(
                                    snapshot.data!.docs[index]['imageurl'])
                                .delete();
                          },
                          key: UniqueKey(),
                          child: ListNotes(
                            n: snapshot.data!.docs[index],
                            docid: snapshot.data!.docs[index].id,
                          ));
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ));
  }
}

class ListNotes extends StatelessWidget {
  final n;
  final docid;
  ListNotes({this.n, this.docid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ViewNote(notes: n);
          },
        ));
      },
      child: Card(
        child: Row(children: [
          Expanded(
            flex: 1,
            child: Image.network(
              "${n['imageurl']}",
              fit: BoxFit.fill,
              height: 130,
            ),
          ),
          Expanded(
            flex: 3,
            child: ListTile(
              title: Text("${n['type_reclamation']}"),
              subtitle: Text("${n['reclamation']}"),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return EditNotes(
                          docid: docid,
                          list: n,
                        );
                      },
                    ));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.red,
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
