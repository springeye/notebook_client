import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notebook/bloc/home_bloc.dart';
import 'package:notebook/screen/home_desktop_screen.dart';

class DesktopContent extends StatelessWidget {
  const DesktopContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeBloc(context),
      child: const HomeDesktopScreen(),
    );
  }
}
