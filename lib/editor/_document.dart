import 'package:flutter/rendering.dart';
import 'package:super_editor/super_editor.dart';

import '_task.dart';

Document createInitialDocument() {
  return MutableDocument(
    nodes: [
      ImageNode(
        id: "1",
        imageUrl: 'https://i.ibb.co/5nvRdx1/flutter-horizon.png',
        metadata: const SingleColumnLayoutComponentStyles(
          width: double.infinity,
          padding: EdgeInsets.zero,
        ).toMetadata(),
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'Welcome to Super Editor π π',
        ),
        metadata: {
          'blockType': header1Attribution,
        },
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text:
              "Super Editor is a toolkit to help you build document editors, document layouts, text fields, and more.",
        ),
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'Ready-made solutions π¦',
        ),
        metadata: {
          'blockType': header2Attribution,
        },
      ),
      ListItemNode.unordered(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'ζζ―ζ εΊεθ‘¨1',
        ),
      ),
      ListItemNode.unordered(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'ζζ―ζ εΊεθ‘¨2',
        ),
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'Quickstart π',
        ),
        metadata: {
          'blockType': header2Attribution,
        },
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(text: 'To get started with your own editing experience, take the following steps:'),
      ),
      TaskNode(
        id: DocumentEditor.createNodeId(),
        isComplete: false,
        text: AttributedText(
          text: 'Create and configure your document, for example, by creating a new MutableDocument.',
        ),
      ),
      TaskNode(
        id: DocumentEditor.createNodeId(),
        isComplete: false,
        text: AttributedText(
          text: "If you want programmatic control over the user's selection and styles, create a DocumentComposer.",
        ),
      ),
      TaskNode(
        id: DocumentEditor.createNodeId(),
        isComplete: false,
        text: AttributedText(
          text:
              "Build a SuperEditor widget in your widget tree, configured with your Document and (optionally) your DocumentComposer.",
        ),
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text:
              "Now, you're off to the races! SuperEditor renders your document, and lets you select, insert, and delete content.",
        ),
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'Explore the toolkit π',
        ),
        metadata: {
          'blockType': header2Attribution,
        },
      ),
      ListItemNode.unordered(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: "Use MutableDocument as an in-memory representation of a document.",
        ),
      ),
      ListItemNode.unordered(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: "Implement your own document data store by implementing the Document api.",
        ),
      ),
      ListItemNode.unordered(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: "Implement your down DocumentLayout to position and size document components however you'd like.",
        ),
      ),
      ListItemNode.unordered(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: "Use SuperSelectableText to paint text with selection boxes and a caret.",
        ),
      ),
      ListItemNode.unordered(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'Use AttributedText to quickly and easily apply metadata spans to a string.',
        ),
      ),
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text:
              "We hope you enjoy using Super Editor. Let us know what you're building, and please file issues for any bugs that you find.",
          spans: AttributedSpans(
            attributions: [
              const SpanMarker(attribution: ExpectedSpans.bold, offset: 0, markerType: SpanMarkerType.start),
              const SpanMarker(attribution: ExpectedSpans.bold, offset: 5, markerType: SpanMarkerType.end),
              const SpanMarker(attribution: ExpectedSpans.italics, offset: 8, markerType: SpanMarkerType.start),
              const SpanMarker(attribution: ExpectedSpans.italics, offset: 12, markerType: SpanMarkerType.end)
            ]
          )
        ),
      ),
    ],
  );
}
