import 'package:flutter/material.dart';
import 'package:knightnotes/database_helpers.dart';
import 'package:knightnotes/state_container.dart';

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
          _pushAddNoteScreen();
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
                _pushEditNoteScreen(note);
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

  void _pushAddNoteScreen() {
    Note note = Note();
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();
    String selectedCategory;
    final container = StateContainer.of(context);

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      List<Category> _categories = container.appState.categories;
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
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text("Select the Category"),
                    items: _categories.map((Category category) {
                      return new DropdownMenuItem(
                        child: new Text(category.name),
                        value: category.name,
                      );
                    }).toList(),
                    onChanged: (String categoryName) {
                      Category categoryFromName = _categories
                          .where((category) => category.name == categoryName)
                          .toList()[0];
                      note.categoryId = categoryFromName.id;
                      setState(() {
                        selectedCategory = categoryName;
                      });
                    },
                  ),
                  new RaisedButton(
                    onPressed: () {
                      _pushAddCategoryScreen();
                    },
                    child: Row(
                      children: <Widget>[Icon(Icons.add), Text("Add Category")],
                    ),
                  )
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  note.title = _titleController.text;
                  note.body = _contentController.text;
                  container.addNote(note);
                  Navigator.pop(context);
                  print("Added note: " + note.toMap().toString());
                },
                child: Text("Submit"),
              ),
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
                onPressed: () {
                  container.deleteNote(note);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _pushEditNoteScreen(Note note) {
    final _titleController = TextEditingController()..text = note.title;
    final _contentController = TextEditingController()..text = note.body;
    final container = StateContainer.of(context);

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Edit Note"),
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
                  container.editNote(note);
                  Navigator.pop(context);
                  print("Edited note: " + note.toMap().toString());
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),
      );
    }));
  }

  void _pushAddCategoryScreen() {
    Category category = Category();
    final container = StateContainer.of(context);

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Add Category"),
        ),
        body: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  decoration: new InputDecoration(labelText: "Category Name"),
                  onSubmitted: (name) async {
                    category.name = name;
                    container.addCategory(category);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _pushAddNoteScreen();
                  },
                )
              ],
            )),
      );
    }));
  }
}
