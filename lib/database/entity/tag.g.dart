// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      json['id'] as String,
      json['text'] as String,
    )
      ..createdTime = DateTime.parse(json['created_time'] as String)
      ..updatedTime = DateTime.parse(json['updated_time'] as String)
      ..noteId = json['note_id'] as String?;

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'created_time': instance.createdTime.toIso8601String(),
      'updated_time': instance.updatedTime.toIso8601String(),
      'note_id': instance.noteId,
    };
