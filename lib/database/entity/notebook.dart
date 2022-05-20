import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'notebook.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
@Entity()
class NoteBook {
  int id=0;
  final  String uuid;
  String? pid;
   String title;
  @Property(type: PropertyType.dateNano)
  final DateTime createdTime;
  @Property(type: PropertyType.dateNano)
   DateTime updatedTime;
  bool deleted = false;
  NoteBook(this.uuid,this.title, this.createdTime, this.updatedTime);
}
