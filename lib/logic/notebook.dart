import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/database/entity/notebook.dart';
import 'package:uuid/uuid.dart';

import '../objectbox.g.dart';
class NotebookControl extends StateNotifier<List<NoteBook>> {
  NotebookControl() : super([]);
  void load(){
    _load().then((value){
      state=value;
    });
  }
  Future<List<NoteBook>> _load() async {
    Store store = await openStore(macosApplicationGroup: "com.github.springeye");
    Box<NoteBook> box = store.box<NoteBook>();
    List<NoteBook> notebooks=box.getAll();
    if (notebooks.isEmpty) {
      Uuid uuid = const Uuid();
      var noteBook = NoteBook(uuid.v4(),"test1", DateTime.now(),DateTime.now());
      box.put(noteBook,mode: PutMode.insert);
      notebooks.add(noteBook);
    }
    store.close();
    return notebooks;

  }
  Future<NoteBook> create(String name,NoteBook? parent) async {
    Store store = await openStore(macosApplicationGroup: "com.github.springeye");
    Box<NoteBook> box = store.box<NoteBook>();
      Uuid uuid = const Uuid();
      var noteBook = NoteBook(uuid.v4(),name, DateTime.now(),DateTime.now());
      if(parent!=null){
        noteBook.pid=parent.uuid;
      }
      box.put(noteBook,mode: PutMode.insert);
      store.close();
      return noteBook;
  }

}

final StateNotifierProvider<NotebookControl, List<NoteBook>> nodebookProvider = StateNotifierProvider<NotebookControl,List<NoteBook>>((StateNotifierProviderRef<NotebookControl, List<NoteBook>> ref) => NotebookControl() );
