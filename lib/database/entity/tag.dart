import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'tag.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
@Entity()
class Tag {
  int id=0;
  late String uuid;
  late String text;
  @Property(type: PropertyType.dateNano)
  late DateTime createdTime;
  @Property(type: PropertyType.dateNano)
  late DateTime updatedTime;
  String? noteId;

}
