
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

import 'editor/_document.dart';
import 'editor/_task.dart';
import 'editor/ext.dart';

class EditorTestWidget extends StatefulWidget {
  const EditorTestWidget({Key? key}) : super(key: key);

  @override
  State<EditorTestWidget> createState() => _EditorTestWidgetState();
}

class _EditorTestWidgetState extends State<EditorTestWidget> {
  String json = "[]";

  @override
  Widget build(BuildContext context) {
    Document initialDocument = createInitialDocument();
    var documentEditor = DocumentEditor(document: initialDocument as MutableDocument);
    return Column(
      children: [
        Expanded(
          child: SuperEditor(
            componentBuilders: [
              ...defaultComponentBuilders,
              TaskComponentBuilder(documentEditor),
            ],
            keyboardActions: [
              ...defaultKeyboardActions,
                  ({
                required EditContext editContext,
                required RawKeyEvent keyEvent,
              }) {
                if (keyEvent.isPrimaryShortcutKeyPressed &&
                    keyEvent.logicalKey == LogicalKeyboardKey.keyS) {
                  setState(() {
                    json = initialDocument.toJson();
                  });
                  return ExecutionInstruction.haltExecution;
                }
                return ExecutionInstruction.continueExecution;
              }
            ],
            editor: documentEditor,
          ),
        ),
        Expanded(
            child: SuperEditor(
              componentBuilders: [
                ...defaultComponentBuilders,
                TaskComponentBuilder(documentEditor),
              ],
              editor: DocumentEditor(
                  document: DocumenToJson.fromJson(json) as MutableDocument),
            ))
      ],
    );
  }
}
