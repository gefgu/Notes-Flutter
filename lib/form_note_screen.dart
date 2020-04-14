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
                    _pushCategoriesScreen();
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

  void _pushCategoriesScreen() {
    final container = StateContainer.of(context);
    List<Category> _categories = container.appState.categories;

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Categories"),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            _pushAddCategoryScreen();
          },
          child: new Icon(Icons.add),
        ),
        body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _categories.length,
          itemBuilder: (BuildContext context, int index) {
            if (index < _categories.length) {
              return ListTile(
                title: new Text(_categories[index].name),
                trailing: PopupMenuButton<String>(
                  onSelected: (String selected) {
                    if (selected == "Edit") {
                      _pushEditCategoryScreen(_categories[index]);
                    } else if (selected == "Delete") {
                      _pushDeleteCategoryScreen(_categories[index]);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "Edit",
                      child: Text("Edit"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Delete",
                      child: Text("Delete"),
                    ),
                  ],
                ),
              );
            }
            return null;
          },
        ),
      );
    }));
  }

  void _pushEditCategoryScreen(Category category) {
    final container = StateContainer.of(context);
    final TextEditingController _nameController = TextEditingController()
      ..text = category.name;

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Edit Category"),
        ),
        body: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: _nameController,
                  decoration: new InputDecoration(labelText: "Category Name"),
                  onSubmitted: (name) async {
                    category.name = name;
                    setState(() {
                      container.editCategory(category);
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _pushCategoriesScreen();
                  },
                )
              ],
            )),
      );
    }));
  }

  void _pushDeleteCategoryScreen(Category category) {
    final container = StateContainer.of(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: new Text("Are you sure to delete ${category.name}?"),
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
                  await container.deleteCategory(category);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _pushCategoriesScreen();
                },
              )
            ],
          );
        });
  }
}
