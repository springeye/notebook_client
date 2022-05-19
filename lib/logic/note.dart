import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/database/dao/note_dao.dart';
import 'package:notebook/database/database.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../model/order_type.dart';
class ShowDetailNote extends StateNotifier<Note?> {
  ShowDetailNote() : super(null);
  void show(Note? node) {
    print("show ${node?.uuid}");
    state=node;
    // state=id;
  }
}
class FilterNote extends StateNotifier<Filter>{
  FilterNote() : super(Filter());
  void setKeyword(String? keyword){
    Filter filter = Filter();
    filter.orderType=state.orderType;
    filter.keyword=keyword;
    state=filter;
  }
  void setOrderType(OrderType type){
    Filter filter = Filter();
    filter.keyword=state.keyword;
    filter.orderType=type;
    state=filter;
  }
  void update(Filter filter){
    state=filter;
  }
}
class SelectNoteList extends StateNotifier<List<String>> {
  SelectNoteList() : super([]);
  void add(String note){
    state=[...state,note];
  }
  void remove(String note){
    List<String> newItem=[...state];
    newItem.remove(note);
    state=[...newItem];
  }
  void clear(){
    state=[];
  }
}
class NoteListControl extends StateNotifier<List<Note>> {
  NoteListControl() : super([]);
  Future<void> load() async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final NoteDao noteDao = database.noteDao;
    List<Note> notes = await noteDao.findAllOrderCreatedTime();
    state=notes;
  }

  Future<void> create(String title,String content) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    Uuid uuid = const Uuid();
    final NoteDao noteDao = database.noteDao;
    Note note = Note(uuid.v4(), "", title, content, DateTime.now(),
        DateTime.now(), false,"",false);
    note.encrypted=note.toMD5();
    await noteDao.insert(note);

  }

  Future<void> delete(List<String> ids) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final NoteDao noteDao = database.noteDao;
    noteDao.deletes(ids);
  }
  Future<void> update(Note note) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final NoteDao noteDao = database.noteDao;
    note.updatedTime = DateTime.now();
    note.synced=false;
    note.encrypted=note.toMD5();
    await noteDao.update(note);
  }
}
class Filter{
  OrderType orderType=OrderType.Created;
  String? keyword;

}

final StateNotifierProvider<SelectNoteList, List<String>> selectNoteListProvider = StateNotifierProvider<SelectNoteList,List<String>>((StateNotifierProviderRef<SelectNoteList, List<String>> ref) => SelectNoteList() );
final StateNotifierProvider<FilterNote,Filter> filterProvider = StateNotifierProvider<FilterNote,Filter>((StateNotifierProviderRef<FilterNote,Filter> ref) => FilterNote() );
final StateNotifierProvider<ShowDetailNote,Note?> showDetailProvider = StateNotifierProvider<ShowDetailNote,Note?>((StateNotifierProviderRef<ShowDetailNote,Note?> ref) => ShowDetailNote() );
final StateNotifierProvider<NoteListControl, List<Note>> noteListProvider = StateNotifierProvider<NoteListControl,List<Note>>((StateNotifierProviderRef<NoteListControl, List<Note>> ref){
  return NoteListControl();
});
final Provider<List<Note>> filterdNoteListProvider = Provider((ProviderRef<List<Note>> ref){
  final Filter filter = ref.watch(filterProvider);
  List<Note> nodes = ref.watch(noteListProvider);
  String? keywork=filter.keyword;
  OrderType type=filter.orderType;
  if(keywork == "no_notebook"){
    nodes=nodes.where((Note element) => element.notebookId==null).toList();
  }else if(keywork!=null && keywork.isNotEmpty){
    nodes=nodes.where((Note element) => element.title.contains(keywork)|| element.content.contains(keywork)).toList();
  }
  if(type==OrderType.Created){
    nodes.sort((p,c){
      return p.createdTime.compareTo(c.createdTime);
    });
  }else{
    nodes.sort((p,c){
      return p.updatedTime.compareTo(c.updatedTime);
    });
  }
  return nodes;
});