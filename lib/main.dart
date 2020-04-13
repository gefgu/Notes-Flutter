import 'package:flutter/material.dart';
import 'package:knightnotes/database_helpers.dart';
import 'package:knightnotes/state_container.dart';
import 'package:knightnotes/add_note_screen.dart';
import 'package:knightnotes/edit_note_screen.dart';

void main() => runApp(new StateContainer(
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knight Notes',
      home: new NotesWidget(),
      initialRoute: '/',
      routes: {
        '/add_note_screen': (context) => AddNoteForm(),
        '/edit_note_screen': (context) => EditNoteForm()
      },
    );
  }
}

class NotesWidget extends StatefulWidget {
  const NotesWidget({Key key}) : super(key: key);

  @override
  NotesWidgetState createState() => NotesWidgetState();
}

class NotesWidgetState extends State<NotesWidget> {
  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    Widget widgetReturn;
    if (container.appState != null) {
      var _notes = container.appState.notes;
      widgetReturn = ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notes.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < _notes.length) {
            return noteTile(_notes[_notes.length - 1 - index]);
          }
          return null;
        },
      );
    } else {
      widgetReturn = Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Knight Notes"),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_note_screen');
        },
        child: Icon(Icons.add),
      ),
      body: widgetReturn,
    );
  }

  Widget noteTile(Note note) {
    return FlatButton(
      child: Container(
        child: Column(
          children: <Widget>[
            new Text(
              note.title,
              style: Theme.of(context).textTheme.title,
            ),
            new SizedBox(
              height: 6.0,
            ),
            new Text(note.body)
          ],
        ),
        padding: const EdgeInsets.all(12.0),
      ),
      onPressed: () {
        _pushNoteScreen(note);
      },
    );
  }

  void _pushNoteScreen(Note note) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
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
    }));
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
                  print("Added note: " + note.toMap().toString());
                  await container.deleteNote(note);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              )
            ],
          );
        });
  }
}

// ADD CRUD TO CATEGORIES, Long press
