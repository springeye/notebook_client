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
  final GlobalKey<AppEditorState> editorKey = GlobalKey<AppEditorState>();
  String get content => "";
  TextEditingController titleController=TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose(){
    titleController.dispose();
    super.dispose();
  }
  Note? note;
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? widget) {
      Note? showNote = ref.watch(showDetailProvider);
       String? content = showNote?.content;

      Document? doc = editorKey.currentState?.doc;
      if(doc!=null && showNote!=null && showNote.uuid!=note?.uuid) {
        MutableDocument mudoc = (doc as MutableDocument);
        mudoc.nodes.clear();
        mudoc.insertNodeAt(0, ParagraphNode(id: DocumentEditor.createNodeId(),
            text: AttributedText(text: content??"")));
        if(note!=null){
          note!.title=titleController.text;
          note!.content=doc.toJson();
          appLog.fine("=======> ${note!.content}");
          
          ref.read(noteListProvider.notifier).update(note!).then((value) {
            note=showNote;
            titleController.text=showNote?.title??"";
          });
        }else{
          note=showNote;
          titleController.text=showNote?.title??"";
        }


      }
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: titleController),
              Expanded(
                child: AppEditor(key: editorKey),
              )
            ],
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
