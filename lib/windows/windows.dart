import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'desktop_window.dart';

class DesktopWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ],
                  stops: [
                    0.0,
                    1.0
                  ]),
            ),
            child: Column(
              children: [
                WindowTitleBarBox(
                  child: Row(children: [
                    Expanded(child: MoveWindow()),
                    WindowButtons()
                  ]),
                ),
                Expanded(child: const DesktopContent())
              ],
            )));
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
        iconNormal: Colors.blueGrey,
        mouseOver: Theme.of(context).hoverColor,
        mouseDown: Theme.of(context).primaryColorDark,
        iconMouseOver: Colors.blueGrey,
        iconMouseDown: Color(0xFFFFD500));

    final closeButtonColors = WindowButtonColors(
        mouseOver: Color(0xFFD32F2F),
        mouseDown: Color(0xFFB71C1C),
        iconNormal: Colors.blueGrey,
        iconMouseOver: Colors.white);
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
