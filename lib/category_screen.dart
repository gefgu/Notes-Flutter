import 'package:flutter/material.dart';
import 'state_container.dart';
import 'data_models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    List<Category> _categories = container.appState.categories;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Categories"),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/form_category', arguments: Category());
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
                    Navigator.pushNamed(context, "/form_category",
                        arguments: _categories[index]);
                  } else if (selected == "Delete") {
                    _pushDeleteCategoryScreen(_categories[index]);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                  Navigator.pushNamedAndRemoveUntil(context, '/category_screen',
                      ModalRoute.withName('form_category'));
                },
              )
            ],
          );
        });
  }
}
