import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notebook/bloc/home_bloc.dart';
import 'package:notebook/bloc/login_bloc.dart';
import 'package:notebook/screen/home_desktop_screen.dart';
import 'package:notebook/screen/login_desktop_screen.dart';

class DesktopContent extends StatelessWidget {
  // This widget is the root of your application.
  final easyload = EasyLoading.init();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p,c){
        return !(c is LoadingState);
      },
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(context),
            child: HomeDesktopScreen(),
          );
        } else if (state is AuthErrorState) {
          return LoginDesktopScreen(
              state.error, state.username, state.password);
        } else if (state is UnauthenticatedState) {
          return LoginDesktopScreen("Could not authenticate");
        } else {
          return BlocProvider(
            create: (context) => HomeBloc(context),
            child: HomeDesktopScreen(),
          );
        }
      },
    );
  }
}
