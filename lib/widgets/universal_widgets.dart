import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:provider/provider.dart';

Widget buildNote(BuildContext context, Note note) {
  final _screenWidth = MediaQuery.of(context).size.width;
  final _container = (_screenWidth - 45) / 2;
  return Container(
    margin: EdgeInsets.only(top: 20.0, left: 15),
    padding: EdgeInsets.all(10),
    // constraints: BoxConstraints(
    //   // minWidth: 20,
    //   maxHeight: 150,
    // ),
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
                                dialogItem(
                                  context,
                                  note: note,
                                  text: "Share with friends",
                                  function: () {
                                    shareNote(note, authProvider.currentUser);
                                  },
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
  ;
}

Widget dialogItem(
  BuildContext context, {
  String text,
  Function function,
  Note note,
  Userr currentUser,
}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: InkWell(
      onTap: () {
        function();
        Navigator.pop(context);
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}

Widget buildUserTile({Userr user, String isFriend}) {
  return Container(
    margin: EdgeInsets.only(top: 15),
    decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ]),
    child: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      return ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        tileColor: Colors.white,
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(user.photoUrl),
        ),
        title: Text(
          user.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: user.uid != authProvider.currentUser.uid || isFriend == "true"
            ? Container(
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
              )
            : SizedBox.shrink(),
      );
    }),
  );
}
