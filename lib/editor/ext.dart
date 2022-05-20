import 'dart:convert';

import 'package:notebook/logging.dart';
import 'package:super_editor/super_editor.dart';

import '_task.dart';

extension DocumenToJson on Document{
  List<Map<String,dynamic>> toJson(){
    List<Map<String,dynamic>> results=[];
    for (DocumentNode node in nodes) {
      results.add(node.toJson());
    }
    return results;
  }
  static Document fromJson(List<Map<String,dynamic>> json){
    List<DocumentNode>  nodes=json.map((Map<String, dynamic> e) => NodeToJson.fromJson(e)).toList();
    return MutableDocument(nodes: nodes);
  }
}
extension NodeToJson on DocumentNode{
  Map<String,dynamic> toJson(){
    Map<String,dynamic> json= {};
    DocumentNode node = this;
    Map<String,dynamic>  params = {};
    params['id']=node.id;
    if(node is ImageNode){
      params['alt']=node.altText;
      params['image_url']=node.imageUrl;

      json['node_type']="image";
      json['attrs']=params;

    }else if(node is HorizontalRuleNode){

    }else if(node is ListItemNode){

      params['type']=node.type.name;
      params['indent']=node.indent;
      params['text']=node.text.toJson();
      json['node_type']="list";
      json['attrs']=params;
    }else if(node is ParagraphNode){
      final Attribution? blockType = node.getMetadataValue('blockType');
      params['blockType']=blockType?.id;
      params['text']=node.text.toJson();
      json['node_type']="paragraph";
      json['attrs']=params;
    }else if(node is TaskNode){
      params['isComplete']=node.isComplete;
      params['text']=node.text.toJson();
      json['node_type']="task";
      json['attrs']=params;
    }

    return json;
  }

  static DocumentNode fromJson(element) {
    print(jsonEncode(element));
    var node_type=element['node_type'];
    var attrs=element['attrs'];
    if(node_type=="paragraph"){
      var id=attrs['id'];
      var text=attrs['text'];
      ParagraphNode node=ParagraphNode(id: id,text: AttrubiteTextToText.fromJson(text));
      // String blockType=element['blockType'];
      // if(blockType!=null) {
      //   node.putMetadataValue("blockType", const NamedAttribution(blockType));
      // }
      return node;
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
      var attText = AttributedText(text: params['text']);
      return attText;
  }
}