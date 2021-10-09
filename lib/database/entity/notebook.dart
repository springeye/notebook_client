import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notebook.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@Entity()
class NoteBook {
  @PrimaryKey()
  String id;
  String pid;
  String title;
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();
  bool deleted = false;

  NoteBook(this.id,this.pid, this.title);

}
