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
}
extension NodeToJson on DocumentNode{
  Map<String,dynamic> toJson(){
    Map<String,dynamic> json= {};
    DocumentNode node = this;
    if(node is ImageNode){
      Map<String,String>  params = {};
      params['alt']=node.altText;
      params['image_url']=node.imageUrl;


      json['node_type']="image";
      json['attrs']=params;

    }else if(node is HorizontalRuleNode){

    }else if(node is ListItemNode){
      Map<String,dynamic>  params = {};
      params['type']=node.type.name;
      params['indent']=node.indent;
      params['text']=node.text.toText();
      json['node_type']="list";
      json['attrs']=params;
    }else if(node is ParagraphNode){
      final Attribution? blockType = node.getMetadataValue('blockType');
      Map<String,dynamic>  params = {};
      params['blockType']=blockType?.id;
      params['text']=node.text.toText();
      json['node_type']="paragraph";
      json['attrs']=params;
    }else if(node is TaskNode){
      Map<String,dynamic>  params = {};
      params['isComplete']=node.isComplete;
      params['text']=node.text.toText();
      json['node_type']="task";
      json['attrs']=params;
    }

    return json;
  }
}
extension AttrubiteTextToText on AttributedText{
  String toText(){
    return text;
  }
}