import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:notebook/windows/windows.dart';

class DesktopApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sss = S.of(context);
    print(sss);
    return Scaffold(
      body: WindowBorder(
        color: Theme.of(context).primaryColorDark,
        width: 0.2,
        child: Row(
          children: [/*LeftSide(),*/ DesktopWindow()],
        ),
      ),
    );
  }
}
