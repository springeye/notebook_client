import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/database/dao/notebook_dao.dart';
import 'package:notebook/database/database.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/database/entity/notebook.dart';
import 'package:uuid/uuid.dart';
import '../model/order_type.dart';
class NotebookControl extends StateNotifier<List<NoteBook>> {
  NotebookControl() : super([]);
  void load(){
    _load().then((value){
      state=value;
    });
  }
  Future<List<NoteBook>> _load() async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    NotebookDao dao = database.notebookDao;
    List<NoteBook> notebooks = await dao.findAll();
    if (notebooks.isEmpty) {
      Uuid uuid = const Uuid();
      await dao.insert(NoteBook(uuid.v4(),"", "test1"));
      notebooks = await dao.findAll();
    }
    return notebooks;

  }
  void create(String name,NoteBook? parent){

  }

}

final StateNotifierProvider<NotebookControl, List<NoteBook>> nodebookProvider = StateNotifierProvider<NotebookControl,List<NoteBook>>((StateNotifierProviderRef<NotebookControl, List<NoteBook>> ref) => NotebookControl() );
