part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoadNote extends HomeEvent {
  String? key;
  OrderType? order;

  HomeLoadNote({this.key, this.order});
}
class ShowLoading extends HomeEvent{}
class HomeDeleted extends HomeEvent {}

class HomeShowTodo extends HomeEvent {}

class HomeShowAllNote extends HomeEvent {}

class HomeShowJoinNotebook extends HomeEvent {}

class HomeShowSearch extends HomeEvent {}

class HomeShowSetting extends HomeEvent {}

class HomeLoadNoteBook extends HomeEvent {}

class CreateNoteEvent extends HomeEvent {
  final String title;
  final String content;

  CreateNoteEvent(this.title, this.content);
}

class UpdateNoteEvent extends HomeEvent {
  final Note note;

  UpdateNoteEvent(this.note);
}

class DeleteNoteEvent extends HomeEvent {
  final List<String> ids;

  DeleteNoteEvent(this.ids);
}

class ShowNoteEvent extends HomeEvent {
  final Note note;
  final int index;

  ShowNoteEvent(this.index, this.note);
}

class ShowNoteBookEvent extends HomeEvent {
  final String key;
  final bool openNotebook;

  ShowNoteBookEvent(this.key, this.openNotebook);
}
