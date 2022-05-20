import 'package:flutter_test/flutter_test.dart';
import 'package:notebook/database/database.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:uuid/uuid.dart';

void main() {
  setUp(() async {});

  tearDown(() async {});
  group("Database Tests", () {
    test("Test Create", () async {
      print("111");
      realm.write(() {
        print("222");
        realm.add(Note(Uuid().v4().toString(),"","",DateTime.now(),DateTime.now(),""));
        print("333");
      });
      print("444");
    });
  });
}
