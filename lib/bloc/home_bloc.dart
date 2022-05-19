import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notebook/database/dao/note_dao.dart';
import 'package:notebook/database/dao/notebook_dao.dart';
import 'package:notebook/database/database.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/database/entity/notebook.dart';
import 'package:notebook/model/order_type.dart';
import 'package:notebook/utils/utils.dart';
import 'package:uuid/uuid.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BuildContext context;

  HomeBloc(this.context) : super(HomeLoadInProgress()){
    on<ShowLoading>((event,emit){
      emit(HomeLoadInProgress());
    });
    on<HomeLoadNote>((event,emit){
      _mapHomeLoadedToState(emit,event.key, event.order ?? OrderType.Updated);
    });
    on<HomeLoadNoteBook>((event,emit){
      _mapHomLoadNoteBookToState(emit);
    });
    on<CreateNoteEvent>((event,emit){
      _mapCreateNoteToState(emit,event);
    });
    on<UpdateNoteEvent>((event,emit){
      _mapUpdateNoteToState(emit,event);
    });
    on<DeleteNoteEvent>((event,emit){
      _mapDeleteNoteToState(emit,event);
    });
    on<ShowNoteEvent>((event,emit){
      _mapShowNoteToState(emit,event);
    });
    on<ShowNoteBookEvent>((event,emit){
       emit(ShowNoteBookState(event.key, event.openNotebook));
    });
  }



  _mapHomLoadNoteBookToState(Emitter<HomeState> emit,) async {
    try {
      final AppDatabase database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      NotebookDao dao = database.notebookDao;
      List<NoteBook> notebooks = await dao.findAll();
      if (notebooks.isEmpty) {
        Uuid uuid = const Uuid();
        await dao.insert(NoteBook(uuid.v4(),"", "test1"));
        notebooks = await dao.findAll();
      }
      emit(HomeLoadNoteBookSuccess(notebooks));
    } catch (e) {
      emit(HomeLoadFailure(e as Error));
    }
  }

  _mapHomeLoadedToState(Emitter<HomeState> emit,String? key, OrderType order) async {
    try {
      add(ShowLoading());
      final AppDatabase database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      final NoteDao noteDao = database.noteDao;
      List<Note> notes = [];
      if (key == null || key == "all") {
        if (order == OrderType.Created) {
          notes = await noteDao.findAllOrderCreatedTime();
        } else {
          notes = await noteDao.findAllOrderUpdatedTime();
        }
      } else if (key == "no_notebook") {
        if (order == OrderType.Created) {
          notes = await noteDao.findByNotebookIsNullOrderCreatedTime();
        } else {
          notes = await noteDao.findByNotebookIsNullOrderUpdatedTime();
        }
      } else {
        if (order == OrderType.Created) {
          notes = await noteDao.findByNotebookIdOrderCreatedTime(key);
        } else {
          notes = await noteDao.findByNotebookIdOrderUpdatedTime(key);
        }
      }
      // if (notes.length <= 0) {
      //   add(CreateNoteEvent(
      //       "未命名",
      //       json.encode(
      //         Document().toDelta().toJson(),
      //       )));
      // } else {
      //   var success = HomeLoadSuccess(notes);
      //   yield success;
      // }
      HomeLoadSuccess success = HomeLoadSuccess(notes, order);
      emit(success);
    } catch (e) {
      emit(HomeLoadFailure(e as Error));
    }
  }

  _mapCreateNoteToState(Emitter<HomeState> emit,CreateNoteEvent event) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    Uuid uuid = const Uuid();
    final NoteDao noteDao = database.noteDao;
    Note note = Note(uuid.v4(), "", event.title, event.content, DateTime.now(),
        DateTime.now(), false,"",false);
    note.encrypted=note.toMD5();
    await noteDao.insert(note);
    emit(CreateNoteSuccess());
    add(HomeLoadNote());
  }

  _mapUpdateNoteToState(Emitter<HomeState> emit,UpdateNoteEvent event) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final NoteDao noteDao = database.noteDao;
    Note note = event.note;
    note.updatedTime = DateTime.now();
    note.synced=false;
    note.encrypted=note.toMD5();
    await noteDao.update(note);
    add(HomeLoadNote());
  }

  _mapDeleteNoteToState(Emitter<HomeState> emit,DeleteNoteEvent event) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final NoteDao noteDao = database.noteDao;
    noteDao.deletes(event.ids);
    add(HomeLoadNote());
  }

  _mapShowNoteToState(Emitter<HomeState> emit,ShowNoteEvent event) async {
    emit(ShowNoteState(event.index, event.note));
  }
}
