import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@Entity()
class Tag {
  @PrimaryKey()
  String id;
  String text;
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();
  String? noteId;

  Tag(this.id, this.text);
}
