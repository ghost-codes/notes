import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/pages/pages.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/providers/notesProvider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

Widget buildNote(BuildContext context, Note note) {
  final _screenWidth = MediaQuery.of(context).size.width;
  final _container = (_screenWidth - 45) / 2;
  return Container(
    margin: EdgeInsets.only(top: 20.0, left: 15),
    padding: EdgeInsets.all(10),
    width: _container,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: Offset(3, 7),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            note.pinned
                ? GestureDetector(
                    child: Icon(Icons.pin_drop),
                    onTap: () async {},
                  )
                : SizedBox.shrink(),
            Spacer(),
            Consumer<AuthenticationProvider>(
              builder: (context, authProvider, child) {
                return GestureDetector(
                  child: Icon(Icons.more_horiz),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Options",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dialogItem(context,
                                    action: "r",
                                    note: note,
                                    text: "Share with friends",
                                    function: () async {
                                  // shareNote(note, authProvider.currentUser);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FriendsList(
                                        currentUser: authProvider.currentUser,
                                        note: note,
                                        // currentUser: authCurrentUser,
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }

                                    // currentUser: auth.currentProvider
                                    ),
                                dialogItem(
                                  context,
                                  note: note,
                                  text: "Label Note",
                                  function: null,
                                ),
                                dialogItem(
                                  context,
                                  note: note,
                                  text: "Delete Note",
                                  function: () async {
                                    note.otherUsers.forEach((element) async {
                                      await notesRef
                                          .doc(element)
                                          .collection("sharedNotes")
                                          .doc(note.noteId)
                                          .delete();
                                    });
                                    await notesRef
                                        .doc(authProvider.currentUser.uid)
                                        .collection("userNotes")
                                        .doc(note.noteId)
                                        .delete();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDisplay(note: note),
              ),
            );
          },
          child: Text(
            note.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteDisplay(note: note)));
          },
          child: Text(
            note.message,
            overflow: TextOverflow.fade,
            maxLines: 15,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(note.label),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timeago.format(
                      DateTime.fromMillisecondsSinceEpoch(note.timeStamp)),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}

Widget buildSharedNote(BuildContext context, Note note) {
  final _screenWidth = MediaQuery.of(context).size.width;
  final _container = (_screenWidth - 45) / 2;
  return Container(
    margin: EdgeInsets.only(top: 20.0, left: 15),
    padding: EdgeInsets.all(10),
    width: _container,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: Offset(3, 7),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            note.pinned
                ? GestureDetector(
                    child: Icon(Icons.pin_drop),
                    onTap: () async {},
                  )
                : SizedBox.shrink(),
            Spacer(),
            Consumer<AuthenticationProvider>(
              builder: (context, authProvider, child) {
                return GestureDetector(
                  child: Icon(Icons.more_horiz),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Options",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                              child: Consumer<NotesProvider>(
                            builder: (context, notesProvider, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dialogItem(context,
                                      note: note, text: "Save as Personal Note",
                                      function: () async {
                                    DocumentSnapshot sharedDoc = await notesRef
                                        .doc(authProvider.currentUser.uid)
                                        .collection("sharedNotes")
                                        .doc(note.noteId)
                                        .get();
                                    if (note.otherUsers
                                        .remove(authProvider.currentUser.uid)) {
                                      await notesRef
                                          .doc(sharedDoc["ownerId"])
                                          .collection("userNotes")
                                          .doc(note.noteId)
                                          .update(
                                              {"otherUsers": note.otherUsers});
                                    }
                                    await notesRef
                                        .doc(authProvider.currentUser.uid)
                                        .collection("sharedNotes")
                                        .doc(note.noteId)
                                        .delete();

                                    String newNoteId = Uuid().v4();
                                    note.timeStamp =
                                        DateTime.now().millisecondsSinceEpoch;
                                    note.noteId = newNoteId;
                                    notesProvider.addNote(
                                        note, authProvider.currentUser);
                                  }),
                                  dialogItem(context,
                                      note: note, text: "Delete Shared Note",
                                      function: () async {
                                    DocumentSnapshot sharedDoc = await notesRef
                                        .doc(authProvider.currentUser.uid)
                                        .collection("sharedNotes")
                                        .doc(note.noteId)
                                        .get();
                                    if (note.otherUsers
                                        .remove(authProvider.currentUser.uid)) {
                                      await notesRef
                                          .doc(sharedDoc["ownerId"])
                                          .collection("userNotes")
                                          .doc(note.noteId)
                                          .update(
                                              {"otherUsers": note.otherUsers});
                                    }
                                    await notesRef
                                        .doc(authProvider.currentUser.uid)
                                        .collection("sharedNotes")
                                        .doc(note.noteId)
                                        .delete();
                                  }),
                                ],
                              );
                            },
                          )),
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
        Text(
          note.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          note.message,
          overflow: TextOverflow.fade,
          maxLines: 15,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Container(
            padding: EdgeInsets.all(5),
            child: Text(note.label),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        )
      ],
    ),
  );
}

shareNote(Note note, Userr currentUser) async {
  if (!note.otherUsers.contains(currentUser.uid)) {
    note.otherUsers.addAll([currentUser.uid]);
    await notesRef
        .doc(currentUser.uid)
        .collection("userNotes")
        .doc(note.noteId)
        .update(
      {
        "otherUsers": note.otherUsers,
      },
    );
    note.otherUsers.forEach(
      (element) {
        notesRef
            .doc(currentUser.uid)
            .collection("sharedNotes")
            .doc(note.noteId)
            .set(
          {
            "noteId": note.noteId,
            "ownerId": currentUser.uid,
          },
        );
      },
    );
  }
}

Widget dialogItem(
  BuildContext context, {
  String action,
  String text,
  Function function,
  Note note,
  Userr currentUser,
}) {
  action = action == null ? 'p' : action;
  return InkWell(
    onTap: () {
      function();
      if (action == 'p') {
        Navigator.pop(context);
      }
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}

Widget buildUserTile(context, {Userr user, Userr currentUser}) {
  return Container(
    margin: EdgeInsets.only(top: 15),
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0, 10),
      ),
    ]),
    child: StreamBuilder<DocumentSnapshot>(
      stream: friendsRef
          .doc(currentUser.uid)
          .collection("friends")
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SizedBox.shrink();
        }
        String isFriend = snapshot.data.exists ? snapshot.data["isFriend"] : "";
        return Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 5),
              user.uid == currentUser.uid || isFriend == "true"
                  ? SizedBox.shrink()
                  : isFriend == "isPending"
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await friendsRef
                                    .doc(currentUser.uid)
                                    .collection("friends")
                                    .doc(user.uid)
                                    .update({"isFriend": "true"});
                                await friendsRef
                                    .doc(user.uid)
                                    .collection("friends")
                                    .doc(currentUser.uid)
                                    .update({"isFriend": "true"});
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Accept",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                await friendsRef
                                    .doc(currentUser.uid)
                                    .collection("friends")
                                    .doc(user.uid)
                                    .delete();
                                await friendsRef
                                    .doc(user.uid)
                                    .collection("friends")
                                    .doc(currentUser.uid)
                                    .delete();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : isFriend == "isSent"
                          ? Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Requested",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () async {
                                    await friendsRef
                                        .doc(currentUser.uid)
                                        .collection("friends")
                                        .doc(user.uid)
                                        .delete();
                                    await friendsRef
                                        .doc(user.uid)
                                        .collection("friends")
                                        .doc(currentUser.uid)
                                        .delete();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () async {
                                await friendsRef
                                    .doc(currentUser.uid)
                                    .collection("friends")
                                    .doc(user.uid)
                                    .set({"isFriend": "isSent"});
                                await friendsRef
                                    .doc(user.uid)
                                    .collection("friends")
                                    .doc(currentUser.uid)
                                    .set({"isFriend": "isPending"});
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
            ],
          ),
        );
      },
    ),
  );
}
