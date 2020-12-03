import 'package:flutter/material.dart';
import 'package:notez/models/models.dart';
import 'package:notez/pages/pages.dart';

class NoteDisplay extends StatefulWidget {
  final Note note;

  const NoteDisplay({Key key, this.note}) : super(key: key);
  @override
  _NoteDisplayState createState() => _NoteDisplayState();
}

class _NoteDisplayState extends State<NoteDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteTaking(note: widget.note)),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Divider(
                height: 15,
              ),
              Text(
                widget.note.message,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
