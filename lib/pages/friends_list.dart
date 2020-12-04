import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';

List<Userr> selectedUsers = [];

class FriendsList extends StatefulWidget {
  final Userr currentUser;
  Note note;

  FriendsList({Key key, this.currentUser, this.note}) : super(key: key);

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Share With"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "(${selectedUsers.length})",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                selectedUsers.forEach((user) {
                  widget.note.otherUsers.add(user.uid);
                  notesRef
                      .doc(user.uid)
                      .collection("sharedNotes")
                      .doc(widget.note.noteId)
                      .set({
                    "noteId": widget.note.noteId,
                    "ownerId": widget.currentUser.uid,
                  });
                  notesRef
                      .doc(widget.currentUser.uid)
                      .collection("userNotes")
                      .doc(widget.note.noteId)
                      .update({"otherUsers": widget.note.otherUsers});
                });
              },
            )
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: friendsRef
              .doc(widget.currentUser.uid)
              .collection("friends")
              // .where("isFriend", isEqualTo: "true")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            List<Userr> userList = [];
            snapshot.data.docs.forEach((element) async {
              DocumentSnapshot doc = await userRef.doc(element.id).get();
              userList.add(Userr.fromDocument(doc));
            });
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return Friend(
                  user: userList[index],
                );
              },
            );
          },
        ));
  }
}

class Friend extends StatefulWidget {
  final Userr user;

  const Friend({Key key, this.user}) : super(key: key);
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = _selected == true ? false : true;
          if (_selected) {
            selectedUsers.add(widget.user);
          } else {
            selectedUsers.remove(widget.user);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ]),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(widget.user.photoUrl),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  widget.user.displayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 5),
              _selected
                  ? Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.check,
                        color: Colors.grey[200],
                      ),
                    )
                  : Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.check,
                        color: Colors.grey,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
