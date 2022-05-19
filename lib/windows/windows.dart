import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'desktop_window.dart';

class DesktopWindow extends StatelessWidget {
  const DesktopWindow({Key? key}) : super(key: key);

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
                  stops: const [
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
                const Expanded(child: DesktopContent())
              ],
            )));
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowButtonColors buttonColors = WindowButtonColors(
        iconNormal: Colors.blueGrey,
        mouseOver: Theme.of(context).hoverColor,
        mouseDown: Theme.of(context).primaryColorDark,
        iconMouseOver: Colors.blueGrey,
        iconMouseDown: const Color(0xFFFFD500));

    final WindowButtonColors closeButtonColors = WindowButtonColors(
        mouseOver: const Color(0xFFD32F2F),
        mouseDown: const Color(0xFFB71C1C),
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
