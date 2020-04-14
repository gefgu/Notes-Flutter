import 'package:flutter/material.dart';
import 'state_container.dart';
import 'data_models/note_model.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key key}) : super(key: key);

  @override
  NoteScreenState createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  Note note;

  @override
  Widget build(BuildContext context) {
    note = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Note Screen",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, "/edit_note_screen",
                  arguments: note);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(note);
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              note.title,
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(
              height: 32.0,
            ),
            Text(note.body)
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Note note) {
    final container = StateContainer.of(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: new Text("Are you sure to delete ${note.title}?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "Delete",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                onPressed: () async {
                  await container.deleteNote(note);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              )
            ],
          );
        });
  }
}
