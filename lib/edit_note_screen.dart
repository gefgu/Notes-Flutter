import 'package:flutter/material.dart';
import 'state_container.dart';
import 'data_models/category_model.dart';
import 'data_models/note_model.dart';

class EditNoteForm extends StatefulWidget {
  const EditNoteForm({Key key}) : super(key: key);

  @override
  EditNoteFormState createState() => EditNoteFormState();
}

class EditNoteFormState extends State<EditNoteForm> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    var _categories = container.appState.categories;

    Note note = ModalRoute.of(context).settings.arguments;
    selectedCategory = _categories
        .where((category) => category.id == note.categoryId)
        .toList()[0]
        .name;
    _titleController..text = note.title;
    _contentController..text = note.body;

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
                await container.editNote(note);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
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
                    setState(() {
                      container.addCategory(category);
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            )),
      );
    }));
  }
}
