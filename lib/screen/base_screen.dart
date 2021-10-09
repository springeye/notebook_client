import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class BaseScreen<T extends StatefulWidget> extends State<T> {
  @protected
  @mustCallSuper
  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
}
