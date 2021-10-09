import 'package:flutter_test/flutter_test.dart';
import 'package:notebook/database/database.dart';

void main() {
  setUp(() async {});

  tearDown(() async {});
  group("Database Tests", () {
    test("Test Query", () async {
      // final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      final database =
          await $FloorAppDatabase.inMemoryDatabaseBuilder().build();

      // final personDao = database.personDao;
      // final person = Person(1, 'Frank');
      //
      // await personDao.insertPerson(person);
      // final lists = await personDao.findAllPersons();
      // assert(lists.isNotEmpty);
    });
  });
}
