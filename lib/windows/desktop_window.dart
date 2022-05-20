import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notebook/editor/_document.dart';
import 'package:notebook/editor/ext.dart';
import 'package:notebook/screen/home_desktop_screen.dart';
import 'package:super_editor/super_editor.dart';

class DesktopContent extends StatelessWidget {
  const DesktopContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeDesktopScreen();
  }
}

