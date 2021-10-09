part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

@immutable
class HomeLoadInProgress extends HomeState {}

@immutable
class HomeLoadFailure extends HomeState {
  final Error error;

  HomeLoadFailure(this.error) : super();

  @override
  List<Object?> get props => [error];
}

@immutable
class HomeLoadSuccess extends HomeState {
  final List<Note> notes;
  final OrderType sort;

  HomeLoadSuccess(this.notes, this.sort) : super() {}

  @override
  List<Object?> get props => [notes, sort];
}

@immutable
class HomeLoadNoteBookSuccess extends HomeState {
  final List<NoteBook> notebooks;

  HomeLoadNoteBookSuccess(this.notebooks) : super() {}

  @override
  List<Object?> get props => [notebooks];
}

@immutable
class CreateNoteSuccess extends HomeState {
  CreateNoteSuccess() : super() {}

  @override
  List<Object?> get props => [];
}

@immutable
class ShowNoteState extends HomeState {
  final Note note;
  final int index;

  ShowNoteState(this.index, this.note) : super() {}

  @override
  List<Object?> get props => [index, note];
}

@immutable
class ShowNoteBookState extends HomeState {
  final String key;
  final bool openNotebook;

  ShowNoteBookState(this.key, this.openNotebook) : super() {}

  @override
  List<Object?> get props => [key, openNotebook];
}
