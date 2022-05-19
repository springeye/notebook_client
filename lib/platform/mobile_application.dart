import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MobileApplication extends StatelessWidget {
  // This widget is the root of your application.
  final TransitionBuilder easyload = EasyLoading.init();

  @override
  Widget build(BuildContext context) {
    return const Text("mobile app");
  }
}
