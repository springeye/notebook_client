import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:notebook/editor/_document.dart';
import 'package:notebook/editor/ext.dart';
import 'package:notebook/network/restclient.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:super_editor/src/core/document.dart';

final logger = Logger();
void main() {
  setUp(() async {});

  tearDown(() async {});
  group("Document Tests", () {
    test("Document to json", () async {
      Document doc=createInitialDocument();
      print(json.encode(doc.toJson()));
    });
    test("Document from json", () async {
      String jsonString="""[{"node_type":"paragraph","attrs":{"id":"794df98b-8ad6-4fe2-9976-2d050db56ca1","blockType":"paragraph","text":{"text":"We hope you enjoy using Super Editor. Let us know what you're building, and please file issues for any bugs that you find.","attrs":[{"mark_type":"start","mark_offset":0,"type":"named","name":"bold"},{"mark_type":"end","mark_offset":5,"type":"named","name":"bold"}]}}}]""";
      List<Map<String,dynamic>> nodes=(jsonDecode(jsonString) as List<dynamic>).cast<Map<String,dynamic>>();
      expect(nodes.isNotEmpty,true);
      var doc=DocumenToJson.fromJson(nodes);
      print(doc);
    });
  });
}
