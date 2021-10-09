part of 'locale_bloc.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();
}

class LocaleChangeEvent extends LocaleEvent {
  final Locale locale;

  LocaleChangeEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}
