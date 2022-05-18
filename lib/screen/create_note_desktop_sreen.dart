import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:notebook/bloc/home_bloc.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/shortcuts/intents.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  String get content =>
      json.encode(contentController.document.toDelta().toJson());
  late TextEditingController titleController;
  late QuillController contentController;

  @override
  void initState() {
    titleController = TextEditingController();
    contentController = QuillController.basic();
    super.initState();
  }

  Note? note;

  save(BuildContext context) {
    var newContent = json.encode(contentController.document.toDelta().toJson());
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
            contentController = QuillController(
                document: Document.fromJson(content),
                selection: textSelection,
                keepStyleOnNewLine: true);
          } else {
            titleController = TextEditingController(text: "");
            contentController =
                QuillController(document: Document(), selection: textSelection);
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: QuillToolbar.basic(
                          showVideoButton: false,
                          showCameraButton: false,
                          showHeaderStyle: false,
                          showIndent: false,
                          showQuote: false,
                          showListCheck: false,
                          showListBullets: false,
                          controller: contentController,
                          webImagePickImpl: _webImagePickImpl,
                          filePickImpl: _filePickImpl,
                          onImagePickCallback: _onImagePickCallback,
                          showAlignmentButtons: true,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: QuillEditor.basic(
                            controller: contentController,
                            readOnly: false, // true for view only mode
                          ),
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

  Future<String?> _webImagePickImpl(OnImagePickCallback onImagePickCallback) {
    return Future.value("");
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
