import 'package:flutter/material.dart';
import 'data_models/category_model.dart';
import 'state_container.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({Key key}) : super(key: key);

  @override
  CategoryFormState createState() => CategoryFormState();
}

class CategoryFormState extends State<CategoryForm> {
  final TextEditingController _nameController = TextEditingController();
  Category category;

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    String barText;
    var functionToCall;

    category = ModalRoute.of(context).settings.arguments;
    if (category.name == null) {
      barText = "Add Category";
      functionToCall = (Category category) => container.addCategory(category);
    } else {
      barText = "Edit Category";
      _nameController..text = category.name;
      functionToCall = (Category category) => container.editCategory(category);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(barText),
      ),
      body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(labelText: "Category Name"),
                autofocus: true,
                controller: _nameController,
                onSubmitted: (name) async {
                  category.name = name;
                  await functionToCall(category);
                  Navigator.pop(context);
                },
              )
            ],
          )),
    );
  }
}
