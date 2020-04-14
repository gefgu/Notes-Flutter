import 'package:flutter/cupertino.dart';
import 'package:knightnotes/database_helpers.dart';

class AppState {
  List<Note> notes;
  List<Category> categories;

  AppState(this.notes, this.categories);
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) {
    return old.data != this.data;
  }
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final AppState appState;

  StateContainer({@required this.child, this.appState});

  static StateContainerState of(BuildContext context) {
    final _InheritedStateContainer _inheritedStateContainer =
        context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
    return _inheritedStateContainer.data;
  }

  @override
  State<StatefulWidget> createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  AppState appState;

  Future<void> addNote(Note note) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    note.id = await helper.insertNote(note);
    setState(() {
      appState.notes.add(note);
    });
    print("Added note: " + note.toMap().toString());
  }

  Future<void> deleteNote(Note note) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteNote(note.id);
    setState(() {
      appState.notes.remove(note);
    });
    print("Delete note:" + note.toMap().toString());
  }

  Future<void> editNote(Note note) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateNote(note);
    setState(() {
      appState.notes
          .where((noteSelected) => noteSelected.id == note.id)
          .toList()[0] = note;
    });
  }

  void addCategory(Category category) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    category.id = await helper.insertCategory(category);
    setState(() {
      appState.categories.add(category);
    });
  }

  Future<void> editCategory(Category category) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateCategory(category);
    setState(() {
      appState.categories
          .where((categorySelected) => category.id == category.id)
          .toList()[0] = category;
    });
  }

  Future<void> deleteCategory(Category category) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteNote(category.id);
    setState(() {
      appState.categories.remove(category);
    });
    print("Delete note:" + category.toMap().toString());
  }

  Future<void> getStuffFromDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Category> _categories = await helper.getAllCategories();
    List<Note> _notes = await helper.getAllNotes();
    for (var category in _categories) {
      print(category.toMap());
    }
    for (var note in _notes) {
      print(note.toMap());
    }
    setState(() {
      appState = AppState(_notes, _categories);
    });
  }

  @override
  void initState() {
    super.initState();
    getStuffFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(data: this, child: widget.child);
  }
}
