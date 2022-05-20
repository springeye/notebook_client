import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'note.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
@Entity()
class Note {
  int id=0;
  final String uuid;
  String? notebookId;
   String title;
   String content;
  @Property(type: PropertyType.dateNano)
  final DateTime createdTime;
  @Property(type: PropertyType.dateNano)
   DateTime updatedTime;
  bool deleted = false;
  late String encrypted;
  bool synced=false;

  Note(this.uuid,this.title, this.content, this.createdTime, this.updatedTime);






}
