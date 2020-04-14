import 'package:knightnotes/database_helpers.dart';

class Category {
  int id;
  String name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCategoryName: name,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Category();

  Category.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnCategoryName];
  }

  @override
  String toString() {
    return name;
  }
}
