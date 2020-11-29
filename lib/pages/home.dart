import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthenticationProvider>(
        
        builder: (context, authProvider, child) {
          return StreamBuilder<QuerySnapshot>(
            stream: notesRef.doc(authProvider.currentUser.uid).collection("userNotes").snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              // List<Widget> notesList = [];
              List data = snapshot.data.docs as List;
              List<Widget> list1 = [];
              List<Widget> list2 = [];
              data
                  .map((e) => Note.fromDocument(e))
                  .toList()
                  .asMap()
                  .forEach((int index, e) {
                if (index.isOdd) {
                  list1.add(buildNote(context, e));
                } else {
                  list2.add(buildNote(context, e));
                }
              });
              // data
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
      ),
    );
  }
}
