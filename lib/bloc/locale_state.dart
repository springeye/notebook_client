part of 'locale_bloc.dart';

abstract class LocaleState extends Equatable {
  LocaleState();
}

class LocaleInitState extends LocaleState {
  @override
  List<Object?> get props => [];
}

class LocaleChangeState extends LocaleState {
  final Locale locale;

  LocaleChangeState(this.locale);

  @override
  List<Object?> get props => [locale];
}
