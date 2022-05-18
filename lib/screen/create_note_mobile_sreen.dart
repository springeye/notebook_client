import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter/material.dart';
import 'package:notebook/bloc/home_bloc.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CreateNoteMobileScreen extends StatefulWidget {
  final Note? note;

  const CreateNoteMobileScreen({Key? key, this.note}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateNoteState(note);
  }
}

class _CreateNoteState extends State<CreateNoteMobileScreen> {
  final Note? note;
  TextEditingController _titleController = TextEditingController();
  QuillController _controller = QuillController.basic();

  _CreateNoteState(this.note);

  @override
  void initState() {
    if (note != null) {
      _titleController.text = note!.title;
      _controller = QuillController(
          document: Document.fromJson(json.decode(note!.content)),
          selection: TextSelection.collapsed(offset: 0));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("未命名笔记"),
        actions: [
          IconButton(
            onPressed: () {
              var jsonObj =
                  json.encode(_controller.document.toDelta().toJson());
              if (note != null) {
                note!.content = jsonObj;
                note!.title = _titleController.text;
                BlocProvider.of<HomeBloc>(context).add(UpdateNoteEvent(note!));
                Navigator.pop(context);
              } else {
                BlocProvider.of<HomeBloc>(context)
                    .add(CreateNoteEvent(_titleController.text, jsonObj));
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            decoration: InputDecoration(
                hintText: "title", contentPadding: EdgeInsets.all(5)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: QuillToolbar.basic(
              controller: _controller,
              webImagePickImpl: _webImagePickImpl,
              filePickImpl: _filePickImpl,
              onImagePickCallback: _onImagePickCallback,
              showAlignmentButtons: true,
            ),
          ),
          Expanded(
            child: Container(
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          )
        ],
      ),
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
