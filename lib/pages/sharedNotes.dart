import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SharedNotes extends StatefulWidget {
  @override
  _SharedNotesState createState() => _SharedNotesState();
}

class _SharedNotesState extends State<SharedNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Shared Notes"),
        ),
        body: Consumer<AuthenticationProvider>(
          builder: (context, authProvider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream:
                  notesRef.doc(authProvider.currentUser.uid).collection("sharedNotes").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Widget> list1 = [];
                List<Widget> list2 = [];
                snapshot.data.docs.asMap().forEach(
                  (index, doc) {
                    if (index.isOdd) {
                      list1.add(FutureBuilder<DocumentSnapshot>(
                        future: notesRef
                            .doc(doc["ownerId"])
                            .collection("userNotes")
                            .doc(doc["noteId"])
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          Note note;

                          note = Note.fromDocument(snapshot.data);
                          // buildNote(context, note);

                          return buildNote(context, note);
                        },
                      ));
                    } else {
                      list2.add(FutureBuilder<DocumentSnapshot>(
                        future: notesRef
                            .doc(doc["ownerId"])
                            .collection("userNotes")
                            .doc(doc["noteId"])
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          Note note;

                          note = Note.fromDocument(snapshot.data);

                          return buildSharedNote(context, note);
                        },
                      ));
                    }
                  },
                );

                return SafeArea(
                  right: false,
                  left: false,
                  child: ListView(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: list1,
                        ),
                        // SizedBox(width: 15),
                        Column(
                          children: list2,
                        ),
                        SizedBox(width: 15),
                      ],
                    )
                  ]),
                );
              },
            );
          },
        ));
  }
}
