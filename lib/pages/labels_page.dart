import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:notez/constants/firestore_constants.dart';
import 'package:notez/models/label_model.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

class Labels extends StatefulWidget {
  @override
  _LabelsState createState() => _LabelsState();
}

class _LabelsState extends State<Labels> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        return SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: createLabel,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Create Label",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: labelsRef
                      .doc(authProvider.currentUser.uid)
                      .collection("userLabels")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<Widget> labelList = [];
                    snapshot.data.docs.forEach((doc) {
                      Label label = Label.fromDocument(doc);
                      labelList
                          .add(buildLabel(label, authProvider.currentUser));
                    });
                    return ListView(
                        padding: EdgeInsets.all(20), children: labelList);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildLabel(Label label, Userr currentUser) {
    List<Widget> listNoteTitles = [];
    label.labelNotesIds.forEach((element) async {
      DocumentSnapshot doc = await notesRef
          .doc(currentUser.uid)
          .collection("userNotes")
          .doc(element)
          .get();
      listNoteTitles.add(Text(
        doc["title"],
        style: TextStyle(color: Colors.grey),
      ));
    });
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Container(
            width: 15,
            decoration: BoxDecoration(
              color: label.labelColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          label.labelName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              label.timeCreated),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: listNoteTitles,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    final _fromKey = GlobalKey<FormState>();
                    showDialog(
                        builder: (context) {
                          TextEditingController labelName =
                              TextEditingController(text: label.labelName);
                          return AlertDialog(
                            title: Text("Create New Label"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Form(
                                    key: _fromKey,
                                    child: TextFormField(
                                      controller: labelName,
                                      onChanged: (value) =>
                                          label.labelName = value,
                                      validator: (value) {
                                        if (value.length < 1) {
                                          return "Label Name must not be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        // hintText: "Label Name",
                                        labelText: "Label Name",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Center(
                                    child: CircleColorPicker(
                                      initialColor: label.labelColor,
                                      size: Size(240, 240),
                                      strokeWidth: 3,
                                      thumbSize: 30,
                                      onChanged: (value) =>
                                          label.labelColor = value,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                      SizedBox(width: 10),
                                      Consumer<AuthenticationProvider>(
                                        builder:
                                            (context, authProvider, child) {
                                          return GestureDetector(
                                            onTap: () async {
                                              if (_fromKey.currentState
                                                  .validate()) {
                                                await labelsRef
                                                    .doc(authProvider
                                                        .currentUser.uid)
                                                    .collection("userLabels")
                                                    .doc(label.labelId)
                                                    .update({
                                                  "labelName": label.labelName,
                                                  "labelId": label.labelId,
                                                  "labelColor":
                                                      label.labelColor.value,
                                                  "labelNoteIds":
                                                      label.labelNotesIds,
                                                  "timeCreated": DateTime.now()
                                                      .millisecondsSinceEpoch,
                                                });

                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                "Done",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        context: context);
                  }),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 20,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Sure you want to unfriend?"),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel")),
                            FlatButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                await labelsRef
                                    .doc(currentUser.uid)
                                    .collection("userLabels")
                                    .doc(label.labelId)
                                    .delete();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Proceed",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  createLabel() {
    TextEditingController labelName = TextEditingController();
    final _fromKey = GlobalKey<FormState>();
    Label label = Label();
    label.labelId = Uuid().v4();
    label.labelColor = Theme.of(context).primaryColor;
    label.labelNotesIds = [];
    return showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text("Create New Label"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _fromKey,
                    child: TextFormField(
                      controller: labelName,
                      onChanged: (value) => label.labelName = value,
                      validator: (value) {
                        if (value.length < 1) {
                          return "Label Name must not be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        // hintText: "Label Name",
                        labelText: "Label Name",
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: CircleColorPicker(
                      initialColor: Theme.of(context).primaryColor,
                      size: Size(240, 240),
                      strokeWidth: 3,
                      thumbSize: 30,
                      onChanged: (value) => label.labelColor = value,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
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
                      SizedBox(width: 10),
                      Consumer<AuthenticationProvider>(
                        builder: (context, authProvider, child) {
                          return GestureDetector(
                            onTap: () async {
                              if (_fromKey.currentState.validate()) {
                                await labelsRef
                                    .doc(authProvider.currentUser.uid)
                                    .collection("userLabels")
                                    .doc(label.labelId)
                                    .set({
                                  "labelName": label.labelName,
                                  "labelId": label.labelId,
                                  "labelColor": label.labelColor.value,
                                  "labelNoteIds": label.labelNotesIds,
                                  "timeCreated":
                                      DateTime.now().millisecondsSinceEpoch,
                                });

                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "Done",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        context: context);
  }
}
