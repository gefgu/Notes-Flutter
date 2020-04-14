import 'package:flutter/material.dart';
import 'state_container.dart';
import 'form_note_screen.dart';
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
        '/form_note_screen': (context) => NoteForm(),
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
          Navigator.pushNamed(context, '/form_note_screen', arguments: Note());
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
// 1 - JOIN ALL ADD EDIT FORMS IN ONE
// 2 - CREATE CLASS TO CATEGORY CRUD

// UI
// GIVE A NICE LOOKING TO THE APP
