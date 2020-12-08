import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/label_model.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/LabelsProvider.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/providers/notesProvider.dart';
import 'package:provider/provider.dart';

class AddLabelToNote extends StatefulWidget {
  final Userr currentUser;
  Note note;

  AddLabelToNote({Key key, this.currentUser, this.note}) : super(key: key);

  @override
  _AddLabelToNoteState createState() => _AddLabelToNoteState();
}

class _AddLabelToNoteState extends State<AddLabelToNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share With"),
        leading:
            Consumer<NotesProvider>(builder: (context, notesProvider, child) {
          return IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              notesProvider.selectedLabels = [];
              Navigator.pop(context);
            },
          );
        }),
        actions: [
          Consumer<NotesProvider>(builder: (context, notesProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "(${notesProvider.selectedLabels.length})",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            );
          }),
          Consumer2<NotesProvider, AuthenticationProvider>(
              builder: (context, notesProvider, authProvider, child) {
            return IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                notesProvider.selectedLabels.forEach(
                  (label) async {
                    if (!widget.note.label.contains(label)) {
                      widget.note.label.add(label);
                      final labell = Label.fromDocument(await labelsRef
                          .doc(authProvider.currentUser.uid)
                          .collection("userLabels")
                          .doc(label)
                          .get());
                      labell.labelNotesIds.add(widget.note.noteId);
                      await labelsRef
                          .doc(authProvider.currentUser.uid)
                          .collection("userLabels")
                          .doc(label)
                          .update({"labelNoteIds": labell.labelNotesIds});
                    }

                    await notesRef
                        .doc(widget.currentUser.uid)
                        .collection("userNotes")
                        .doc(widget.note.noteId)
                        .update({"label": widget.note.label});
                  },
                );
                notesProvider.selectedLabels = [];
                Navigator.pop(context);
              },
            );
          })
        ],
      ),
      body: Consumer<LabelsProvider>(builder: (context, labelsProv, child) {
        return FutureBuilder<void>(
          future: labelsProv.fetchUserLabels(widget.currentUser.uid),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) {
            //   return Center(child: CircularProgressIndicator());
            // }
            final List labels = labelsProv.getLabels();
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView.builder(
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    return Labell(
                      label: labels[index],
                    );
                  },
                ));
          },
        );
      }),
    );
  }
}

class Labell extends StatefulWidget {
  final Label label;

  const Labell({Key key, this.label}) : super(key: key);
  @override
  _LabellState createState() => _LabellState();
}

class _LabellState extends State<Labell> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(builder: (context, notesProvider, child) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selected = _selected == true ? false : true;
            if (_selected) {
              notesProvider.addToSelectedLabels(widget.label.labelId);
            }
            if (_selected == false) {
              print(_selected);
              notesProvider.removeFromSelectedLabel(widget.label.labelId);
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: widget.label.labelColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.check,
                        color: widget.label.labelColor,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.label.labelName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                _selected
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(3),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(3),
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
    });
  }
}
