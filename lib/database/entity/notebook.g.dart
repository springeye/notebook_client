// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notebook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteBook _$NoteBookFromJson(Map<String, dynamic> json) => NoteBook(
      json['uuid'] as String,
      json['title'] as String,
      DateTime.parse(json['created_time'] as String),
      DateTime.parse(json['updated_time'] as String),
    )
      ..id = json['id'] as int
      ..pid = json['pid'] as String?
      ..deleted = json['deleted'] as bool;

Map<String, dynamic> _$NoteBookToJson(NoteBook instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'pid': instance.pid,
      'title': instance.title,
      'created_time': instance.createdTime.toIso8601String(),
      'updated_time': instance.updatedTime.toIso8601String(),
      'deleted': instance.deleted,
    };
