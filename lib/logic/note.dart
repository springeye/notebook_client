import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/database/database.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../model/order_type.dart';
import '../objectbox.g.dart';
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
    Store store = await openStore(macosApplicationGroup: "com.github.springeye");
    state=store.box<Note>().getAll();
    store.close();
  }

  Future<Note> create(String title,String content)  async {
    Uuid uuid = const Uuid();
    Note note = Note(uuid.v4(),title, content,DateTime.now(),DateTime.now());
    note.encrypted=note.toMD5();
    Store store = await openStore(macosApplicationGroup: "com.github.springeye");
    store.box<Note>().put(note);
    store.close();
    return note;
  }

  Future<void> delete(List<String> ids) async {
    Store store = await openStore(macosApplicationGroup: "com.github.springeye");
    Box<Note> box = store.box<Note>();
    List<Note> notes=box.query(Note_.uuid.oneOf(ids)).build().find();
    for (Note element in notes) {
      element.deleted=true;
      element.synced=false;
    }
    box.putMany(notes,mode: PutMode.update);
    store.close();

  }
  Future<void> update(Note newNote) async {
    Store store = await openStore(macosApplicationGroup: "com.github.springeye");
    Box<Note> box = store.box<Note>();
    Note? note=box.query(Note_.uuid.equals(newNote.uuid)).build().findFirst();
    if(note!=null){
      if(newNote.title!=note.title)note.title=newNote.title;
      if(newNote.content!=note.content)note.content=newNote.content;
      if(newNote.notebookId!=note.notebookId)note.notebookId=newNote.notebookId;
      note.updatedTime=DateTime.now();
      note.synced=false;
      box.put(note,mode: PutMode.update);
    }
    store.close();
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
    nodes.sort((Note p,Note c){
      return p.createdTime.compareTo(c.createdTime);
    });
  }else{
    nodes.sort((Note p,Note c){
      return p.updatedTime.compareTo(c.updatedTime);
    });
  }
  return nodes;
});