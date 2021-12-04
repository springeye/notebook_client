import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notebook/datastore/app_data_store.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initState) : super(initState);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginRequestEvent) {
      yield LoadingState();
      await Future.delayed(Duration(seconds: 3));
      yield AuthenticatedState();
    } else if (event is LogoutEvent) {
      var store = AppDataStore.of();
      // await store.setString("did", null);
      // await store.setString("sid", null);
      // await store.setString("host", null);
      yield UnauthenticatedState();
    }
  }
}
