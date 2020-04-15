import 'data_models/note_model.dart';
import 'data_models/category_model.dart';
import 'package:flutter/material.dart';
import 'state_container.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key key}) : super(key: key);

  @override
  NoteFormState createState() => NoteFormState();
}

class NoteFormState extends State<NoteForm> {
  Note note;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    var _categories = container.appState.categories;
    String barText;
    note = ModalRoute.of(context).settings.arguments;
    var functionToCall;

    if (note.title == null) {
      barText = "Add Note";
      functionToCall = (Note note) => container.addNote(note);
    } else {
      barText = "Edit Note";
      _titleController..text = note.title;
      _contentController..text = note.body;
      selectedCategory = container.appState.categories
          .where((category) => category.id == note.categoryId)
          .toList()[0]
          .name;
      functionToCall = (Note note) => container.editNote(note);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(barText),
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
            SizedBox(
              height: 36,
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
                RaisedButton(
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.edit),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Edit Categories")
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/category_screen');
                  },
                ),
              ],
            ),
            SizedBox(
              height: 36,
            ),
            RaisedButton(
              onPressed: () async {
                note.title = _titleController.text;
                note.body = _contentController.text;
                await functionToCall(note);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

// Create Categories Screen Class and form
