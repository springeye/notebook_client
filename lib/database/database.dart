// required package imports

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:notebook/database/dao/note_dao.dart';
import 'package:notebook/database/dao/notebook_dao.dart';
import 'package:notebook/database/dao/tag_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'converts/datetime_converter.dart';
import 'converts/string_array_convert.dart';
import 'entity/note.dart';
import 'entity/notebook.dart';
import 'entity/tag.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([StringArrayConvert, DateTimeConverter])
@Database(version: 1, entities: [Note, NoteBook, Tag])
abstract class AppDatabase extends FloorDatabase {
  NotebookDao get notebookDao;

  NoteDao get noteDao;

  TagDao get tagDao;
}
