import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/editor/ext.dart';
import 'package:notebook/logging.dart';
import 'package:notebook/logic/note.dart';
import 'package:notebook/shortcuts/intents.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_editor/super_editor.dart';

import '../editor/_task.dart';
import '../editor/editor.dart';

class CreateNoteDesktopScreen extends StatefulWidget {
  const CreateNoteDesktopScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateNoteState();
  }
}

class _CreateNoteState extends State<CreateNoteDesktopScreen> {
  String get title => titleController.text;
  final GlobalKey<AppEditorState> editorKey = GlobalKey<AppEditorState>();
  String get content => "";
  late TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController();
    super.initState();
  }

  Note? note;
  save(BuildContext context, WidgetRef ref) {
    appLog.fine("保存文档");
    Document? doc=editorKey.currentState?.doc;
    if(doc==null)return;
    String newContent = json.encode(doc.toJson());
    appLog.fine(newContent);
    // String newTitle = titleController.text;
    // if (note != null) {
    //   if (newTitle != note!.title || newContent != note!.content) {
    //     note!.title = newTitle;
    //     note!.content = newContent;
    //     ref.read(noteListProvider.notifier).update(note!);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? widget) {
      Note? showNote = ref.watch(showDetailProvider);
      titleController.value = TextEditingValue(text: showNote?.title ?? "");
       String? content = showNote?.content;
       content ??= "";
       AppEditor baseEditor = AppEditor(key: editorKey,doc: MutableDocument(nodes: [
         ParagraphNode(
           id: DocumentEditor.createNodeId(),
           text: AttributedText(
             text:
             content,
           ),
         ),
       ]),);
      return Scaffold(
        body: MouseRegion(
          onHover: (PointerHoverEvent event) {
            // print("onHover");
          },
          onEnter: (PointerEnterEvent event) {
            // print("onEnter");
          },
          onExit: (PointerExitEvent event) {
            save(context, ref);
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
                SaveIntent: CallbackAction<SaveIntent>(onInvoke: (SaveIntent intent) {
                  save(context, ref);
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: InputDecoration(
                          hintText: S.of(context)!.hint_title,
                          contentPadding: EdgeInsets.all(5)),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        child: baseEditor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<String?> _filePickImpl(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
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
