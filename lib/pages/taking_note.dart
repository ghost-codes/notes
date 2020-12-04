import 'package:flutter/material.dart';
import 'package:notez/models/note_model.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/providers/notesProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NoteTaking extends StatefulWidget {
  Note note;

  NoteTaking({this.note});

  @override
  _NoteTakingState createState() => _NoteTakingState();
}

class _NoteTakingState extends State<NoteTaking> {
  TextEditingController _messageInputController = TextEditingController();
  TextEditingController _titleInputController = TextEditingController();
  Note note = Note();
  @override
  void initState() {
    
    super.initState();
    if (widget.note != null) {
      note = widget.note;
      _titleInputController.text = note.title;
      _messageInputController.text = note.message;
    } else {
      String noteId = Uuid().v4();
      note.noteId = noteId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.00),
        child: Consumer<NotesProvider>(
          builder: (context, notesProvider, child) {
            return AppBar(
              title: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _titleInputController,
                builder: (_, value, __) {
                  if (value.text.trim().length > 0) {
                    return Text(value.text);
                  }
                  return Text("Untitled Note");
                },
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _titleInputController.clear();
                  _messageInputController.clear();
                  notesProvider.setPageIndex(0);
                },
              ),
              actions: [
                Consumer<AuthenticationProvider>(
                  builder: (context, authProvider, child) {
                    return IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        note.pinned = false;
                        note.otherUsers = [];
                        if (note.label == null) {
                          note.label = "Unlabelled";
                        }
                        if (note.title == null) {
                          note.title = "Untitled";
                        }
                        note.timeStamp = DateTime.now().millisecondsSinceEpoch;
                        notesProvider.addNote(note, authProvider.currentUser);
                        _titleInputController.clear();
                        _messageInputController.clear();
                        notesProvider.setPageIndex(0);
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Consumer<NotesProvider>(
          builder: (context, notesProvider, child) {
            Provider.of<NotesProvider>(context, listen: false);
            return Column(
              children: [
                TextFormField(
                  onChanged: (String val) {
                    // notesProvider.setTtile(_titleInputController.text);
                    note.title = val.trim().length != 0
                        ? _titleInputController.text
                        : "Untitled Note";
                  },
                  controller: _titleInputController,
                  decoration: InputDecoration(hintText: "Title"),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: TextFormField(
                          onChanged: (String val) {
                            note.message = val;
                          },
                          controller: _messageInputController,
                          maxLines: 100,
                          decoration: InputDecoration(
                            hintText: "Make Note",
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
