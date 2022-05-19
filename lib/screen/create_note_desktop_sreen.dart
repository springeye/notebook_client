import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:notebook/bloc/home_bloc.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/shortcuts/intents.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_editor/super_editor.dart';

class CreateNoteDesktopScreen extends StatefulWidget {
  CreateNoteDesktopScreen({
    Key? key,
  }) : super(key: key);

  String get title => state.title;

  String get content => state.content;
  late _CreateNoteState state;

  @override
  State<StatefulWidget> createState() {
    state = _CreateNoteState();
    return state;
  }
}

class _CreateNoteState extends State<CreateNoteDesktopScreen> {
  String get title => titleController.text;

  String get content => "";
  late TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController();
    super.initState();
  }

  Note? note;

  save(BuildContext context) {
    var newContent = json.encode("");
    var newTitle = titleController.text;
    if (note != null) {
      if (newTitle != note!.title || newContent != note!.content) {
        note!.title = newTitle;
        note!.content = newContent;
        BlocProvider.of<HomeBloc>(context).add(UpdateNoteEvent(note!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (pre, current) {
        if (pre is ShowNoteState && current is ShowNoteState) {
          save(context);
        }
        return current is ShowNoteState;
      },
      builder: (context, state) {
        if (state is ShowNoteState) {
          const textSelection = const TextSelection.collapsed(offset: 0);
          if (state.index >= 0) {
            note = state.note;
            titleController = TextEditingController(text: note!.title);
            var content = json.decode(note!.content);

          } else {
            titleController = TextEditingController(text: "");

          }
        }
        return Scaffold(
          body: MouseRegion(
            onHover: (event) {
              // print("onHover");
            },
            onEnter: (event) {
              // print("onEnter");
            },
            onExit: (event) {
              save(context);
            },
            /**
             * 快捷键处理
             */
            child: Shortcuts(
              shortcuts: <LogicalKeySet, Intent>{
                LogicalKeySet(
                        LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                    SaveIntent()
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  SaveIntent: CallbackAction<SaveIntent>(onInvoke: (intent) {
                    save(context);
                  })
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        decoration: InputDecoration(
                            hintText: S.of(context)!.hint_title,
                            contentPadding: EdgeInsets.all(5)),
                      ),
                      Expanded(
                        child: Container(
                          child: SuperEditor(editor: DocumentEditor(document: MutableDocument())),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }


  Future<String?> _filePickImpl(BuildContext context) async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    return Future.value(result?.files.single.path);
    // return await FilesystemPicker.open(
    //   context: context,
    //   rootDirectory: Directory("/"),
    //   fsType: FilesystemType.file,
    //   allowedExtensions: [".jpg", ".jpeg", ".gif", ".webp", ".png", ".bmp"],
    //   fileTileSelectMode: FileTileSelectMode.wholeTile,
    // );
  }
}
