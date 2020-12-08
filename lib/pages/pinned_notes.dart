import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PinnedNotesPage extends StatefulWidget {
  @override
  _PinnedNotesPageState createState() => _PinnedNotesPageState();
}

class _PinnedNotesPageState extends State<PinnedNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pinned Notes"),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return StreamBuilder<QuerySnapshot>(
            stream: notesRef
                .doc(authProvider.currentUser.uid)
                .collection("userNotes")
                .orderBy(
                  "timeStamp",
                  descending: true,
                )
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              // List<Widget> notesList = [];
              List data = snapshot.data.docs as List;
              List<Widget> list1 = [];
              List<Widget> list2 = [];
              List pinned = [];
              data.map((e) => Note.fromDocument(e)).toList().forEach((element) {
                if (element.pinned) {
                  pinned.add(element);
                }
              });
              pinned.asMap().forEach((int index, e) {
                if (index.isEven) {
                  list1.add(buildNote(context, e));
                } else {
                  list2.add(buildNote(context, e));
                }
              });
              // data
              return ListView(children: [
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
              ]);
            },
          );
        },
      ),
    );
  }
}
