import 'package:flutter/material.dart';
import 'package:knightnotes/database_helpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knight Notes',
      home: NotesWidget(),
    );
  }
}

class NotesWidget extends StatefulWidget {
  const NotesWidget({Key key}) : super(key: key);

  @override
  NotesWidgetState createState() => NotesWidgetState();
}

class NotesWidgetState extends State<NotesWidget> {
  List<Note> _notes;
  List<Category> _categories;

  Future<dynamic> getStuffFromDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    _categories = await helper.getAllCategories();
    _notes = await helper.getAllNotes();
    print([_categories, _notes].toString());
    return [_categories, _notes];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Knight Notes"),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _pushAddNoteScreen();
        },
        child: Icon(Icons.add),
      ),
      body: new FutureBuilder(
        future: getStuffFromDatabase(),
        builder: (context, snapshot) {
          Widget widgetReturn;
          if (snapshot.hasData) {
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
          } else if (snapshot.hasError) {
            widgetReturn = Text(snapshot.error.toString());
          } else {
            widgetReturn = CircularProgressIndicator();
          }
          return widgetReturn;
        },
      ),
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
              onPressed: () {},
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

  void _pushAddNoteScreen() {
    Note note = Note();
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Add Note"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: new InputDecoration(
                  labelText: "Title",
                ),
                controller: _titleController,
              ),
              TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: new InputDecoration(
                  labelText: "Content",
                ),
                controller: _contentController,
              ),
              RaisedButton(
                onPressed: () async {
                  note.title = _titleController.text;
                  note.body = _contentController.text;
                  _addNote(note);
                  Navigator.pop(context);
                  print("Added note: " + note.toMap().toString());
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),
      );
    }));
  }

  void _addNote(Note note) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    note.id = await helper.insertNote(note);
    setState(() {});
  }

  void _confirmDelete(Note note) {
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
                onPressed: () {
                  _deleteNote(note);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _deleteNote(Note note) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteNote(note.id);
    setState(() {});
  }
}
