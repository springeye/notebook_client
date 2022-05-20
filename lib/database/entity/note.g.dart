// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      json['uuid'] as String,
      json['title'] as String,
      json['content'] as String,
      DateTime.parse(json['created_time'] as String),
      DateTime.parse(json['updated_time'] as String),
    )
      ..id = json['id'] as int
      ..notebookId = json['notebook_id'] as String?
      ..deleted = json['deleted'] as bool
      ..encrypted = json['encrypted'] as String
      ..synced = json['synced'] as bool;

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'notebook_id': instance.notebookId,
      'title': instance.title,
      'content': instance.content,
      'created_time': instance.createdTime.toIso8601String(),
      'updated_time': instance.updatedTime.toIso8601String(),
      'deleted': instance.deleted,
      'encrypted': instance.encrypted,
      'synced': instance.synced,
    };
