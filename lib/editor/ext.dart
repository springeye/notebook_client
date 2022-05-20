import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:notebook/logging.dart';
import 'package:super_editor/super_editor.dart';

import '_task.dart';

extension DocumenToJson on Document{
  String toJson(){
    List<Map<String,dynamic>> results=[];
    for (DocumentNode node in nodes) {
      results.add(node.toJson());
    }
    return jsonEncode(results);
  }
  static Document fromJson(String json){
    List<Map<String,dynamic>> items=(jsonDecode(json) as List<dynamic>).cast<Map<String,dynamic>>();
    List<DocumentNode>  nodes=items.map((Map<String, dynamic> e) => NodeToJson.fromJson(e)).toList();
    return MutableDocument(nodes: nodes);
  }
}
extension NodeToJson on DocumentNode{
  Map<String,dynamic> toJson(){
    Map<String,dynamic> json= {};
    DocumentNode node = this;
    Map<String,dynamic>  params = {};
    params['id']=node.id;
    // params['']=node.beginningPosition;
    // params['']=node.endPosition;
    if(node is ImageNode){
      params['alt']=node.altText;
      params['image_url']=node.imageUrl;

      json['node_type']="image";
      json['attrs']=params;

    }else if(node is HorizontalRuleNode){

    }else if(node is ListItemNode){

      params['type']=node.type.name;
      params['indent']=node.indent;
      params['body']=node.text.toJson();
      json['node_type']="list";
      json['attrs']=params;
    }else if(node is ParagraphNode){
      final Attribution? blockType = node.getMetadataValue('blockType');
      params['blockType']=blockType?.id;
      params['body']=node.text.toJson();
      json['node_type']="paragraph";
      json['attrs']=params;
    }else if(node is TaskNode){
      params['isComplete']=node.isComplete;
      params['body']=node.text.toJson();
      json['node_type']="task";
      json['attrs']=params;
    }

    return json;
  }

  static DocumentNode fromJson(element) {
    appLog.fine("DocumentNode fromJson: ${jsonEncode(element)}");
    var node_type=element['node_type'];
    var attrs=element['attrs'];
    var id=attrs['id'];
    if(node_type=="paragraph"){
      var text=attrs['body'];
      ParagraphNode node=ParagraphNode(id: id,text: AttrubiteTextToText.fromJson(text));
      String? blockType=attrs['blockType'];
      if(blockType!=null) {
        node.putMetadataValue("blockType", NamedAttribution(blockType));
      }
      return node;
    }else if(node_type=="image"){
      return ImageNode(id: id, imageUrl:attrs['image_url'],altText: attrs['alt']);
    }else if(node_type=="list"){
      if(attrs['type']=="unordered") {
        return ListItemNode.unordered(
            id: id, text: AttrubiteTextToText.fromJson(attrs['body']));
      }else{
        return ListItemNode.ordered(
            id: id, text: AttrubiteTextToText.fromJson(attrs['body']));
      }
    }else if(node_type=="task"){
      return TaskNode(id: id, text:  AttrubiteTextToText.fromJson(attrs['body']), isComplete: attrs['isComplete']);
    }
    throw Exception("node error type: ${node_type}");
  }
}
extension AttrubiteTextToText on AttributedText{
  Map<String,dynamic> toJson(){
    Map<String,dynamic>  params = {};
    params['text']=text;
    List<Map<String,dynamic>> attrs=[];
    visitAttributions((AttributedText fullText, int index, Set<Attribution> attributions, AttributionVisitEvent event) {
      for (Attribution element in attributions) {
        Map<String,dynamic> attr={};
        attr['mark_type']=event.name;
        attr['mark_offset']=index;
        attr['event']=event.name;
        if(element is NamedAttribution){
          attr['type']="named";
          attr['name']=element.name;

        }else if(element is LinkAttribution){
          attr['type']="link";
          attr['url']=element.url;
        }
        attrs.add(attr);
      }

      params['attrs']=attrs;
    });
    appLog.fine("params=====> ${json.encode(params)}\n\n");


    return params;
  }

  static AttributedText fromJson(Map<String,dynamic> params) {
      AttributedText attText = AttributedText(text: params['text']);
      List<Map<String, dynamic>> attrs=(params['attrs'] as List<dynamic>).cast<Map<String,dynamic>>();
      int start=-1;
      int end=-1;
      for (Map<String, dynamic> value in attrs) {
        String name = value['name'];
        int offset = value['mark_offset'];
        String event = value['event'];
        if(event==AttributionVisitEvent.start.name){
          start=offset;
        }else if(event==AttributionVisitEvent.end.name) {
          end = offset;
        }
        if(start!=-1 && end!=-1){
          attText.addAttribution(NamedAttribution(name), SpanRange(start: start, end: end));
          start=-1;
          end=-1;
        }

      }
      return attText;
  }
}
extension PrimaryShortcutKey on RawKeyEvent {
  bool get isPrimaryShortcutKeyPressed =>
      (Platform.isMacOS && isMetaPressed) ||
          (!Platform.isMacOS && isControlPressed);
}