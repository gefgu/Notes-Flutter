import 'package:flutter/material.dart';
import 'state_container.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';
import 'note_screen.dart';
import 'data_models/note_model.dart';

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
        '/edit_note_screen': (context) => EditNoteForm(),
        '/note_screen': (context) => NoteScreen(),
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
        Navigator.pushNamed(context, '/note_screen', arguments: note);
      },
    );
  }
}

// MEGA REFACTOR
// 2 - JOIN ALL ADD EDIT FORMS IN ONE

// UI
// GIVE A NICE LOOKING TO THE APP
