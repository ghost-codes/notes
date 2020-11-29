import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  String searchvalue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Friend")),
      body: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() {
                searchvalue = value;
              }),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                suffixIcon: Icon(Icons.search),
                hintText: "Search",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            searchvalue.trim().length != 0
                ? FutureBuilder<QuerySnapshot>(
                    future: userRef
                        .where("displayName",
                            isGreaterThanOrEqualTo: searchvalue.trim())
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          child: Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                      List<Widget> userList = [];
                      snapshot.data.docs.forEach((doc) {
                        Userr user = Userr.fromDocument(doc);
                        userList.add(buildUserTile(user: user));
                      });
                      return SingleChildScrollView(
                        child: Column(
                          children: userList,
                        ),
                      );
                    })
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

 
}
