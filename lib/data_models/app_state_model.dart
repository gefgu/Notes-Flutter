import 'category_model.dart';
import 'note_model.dart';

class AppState {
  List<Note> notes;
  List<Category> categories;

  AppState(this.notes, this.categories);
}
