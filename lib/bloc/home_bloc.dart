import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  HomeBloc(this.context) : super(HomeLoadInProgress());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeLoadNote) {
      yield* _mapHomeLoadedToState(event.key, event.order ?? OrderType.Updated);
    } else if (event is HomeLoadNoteBook) {
      yield* _mapHomLoadNoteBookToState();
    } else if (event is CreateNoteEvent) {
      yield* _mapCreateNoteToState(event);
    } else if (event is UpdateNoteEvent) {
      yield* _mapUpdateNoteToState(event);
    } else if (event is DeleteNoteEvent) {
      yield* _mapDeleteNoteToState(event);
    } else if (event is ShowNoteEvent) {
      yield* _mapShowNoteToState(event);
    } else if (event is ShowNoteBookEvent) {
      yield ShowNoteBookState(event.key, event.openNotebook);
    }
  }

  Stream<HomeState> _mapHomLoadNoteBookToState() async* {
    try {
      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      var dao = database.notebookDao;
      var notebooks = await dao.findAll();
      if (notebooks.length <= 0) {
        var uuid = Uuid();
        await dao.insert(NoteBook(uuid.v4(),"", "test1"));
        notebooks = await dao.findAll();
      }
      yield HomeLoadNoteBookSuccess(notebooks);
    } catch (e) {
      yield HomeLoadFailure(e as Error);
    }
  }

  Stream<HomeState> _mapHomeLoadedToState(String? key, OrderType order) async* {
    try {
      yield HomeLoadInProgress();
      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      final noteDao = database.noteDao;
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
      var success = HomeLoadSuccess(notes, order);
      yield success;
    } catch (e) {
      yield HomeLoadFailure(e as Error);
    }
  }

  Stream<HomeState> _mapCreateNoteToState(CreateNoteEvent event) async* {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    var uuid = Uuid();
    final noteDao = database.noteDao;
    var note = Note(uuid.v4(), "", event.title, event.content, DateTime.now(),
        DateTime.now(), false,"",false);
    note.encrypted=note.toMD5();
    await noteDao.insert(note);
    yield CreateNoteSuccess();
    add(HomeLoadNote());
  }

  Stream<HomeState> _mapUpdateNoteToState(UpdateNoteEvent event) async* {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final noteDao = database.noteDao;
    var note = event.note;
    note.updatedTime = DateTime.now();
    note.synced=false;
    note.encrypted=note.toMD5();
    await noteDao.update(note);
    add(HomeLoadNote());
  }

  Stream<HomeState> _mapDeleteNoteToState(DeleteNoteEvent event) async* {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final noteDao = database.noteDao;
    noteDao.deletes(event.ids);
    add(HomeLoadNote());
  }

  Stream<HomeState> _mapShowNoteToState(ShowNoteEvent event) async* {
    yield ShowNoteState(event.index, event.note);
  }
}
