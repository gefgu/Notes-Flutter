import 'package:knightnotes/database_helpers.dart';

class Note {
  int id;
  String title;
  String body;
  int categoryId;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnBody: body,
      columnForeign: categoryId,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Note();

  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    body = map[columnBody];
    categoryId = map[columnForeign];
  }
}
