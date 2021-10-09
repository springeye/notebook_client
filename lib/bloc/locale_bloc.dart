import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc(Locale initLocale) : super(LocaleChangeState(initLocale)) {
    on<LocaleEvent>((event, emit) {
      if (event is LocaleChangeEvent) {
        emit.call(LocaleChangeState(event.locale));
      }
    });
  }
}
