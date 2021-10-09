import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@Entity()
class Note {
  @PrimaryKey()
  final String uuid;
  String? notebookId;
  String title;
  String content;
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();
  bool deleted = false;
  String encrypted;
  bool synced;
  Note(this.uuid, this.notebookId, this.title, this.content, this.createdTime,
      this.updatedTime, this.deleted,this.encrypted,this.synced);
  static Note newEmpty(){
      return Note("","","","",DateTime.now(),DateTime.now(),false,"",false);
  }
}
