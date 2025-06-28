

import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {

  final notes;
  const ViewNote({Key? key, this.notes}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC2E0E3),
      appBar: AppBar(
        title: Text('Consulter Reclamation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                 Image.network(
                  "${widget.notes['imageurl']}",
                  height: 350,
                  fit: BoxFit.cover,
                ),

            SizedBox(height: 16),

            Center(
              child: Text(
                    "${widget.notes['type_reclamation']}",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                  ),
            ),

            SizedBox(height: 25),
                 Center(
                   child: Text(
                    "${widget.notes['reclamation']}",
                    style: TextStyle(fontSize: 16),
                ),
                 ),
          ],
        ),

    );

  }
}
