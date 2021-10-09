import 'package:floor/floor.dart';
import 'package:notebook/database/entity/notebook.dart';

@dao
abstract class NotebookDao {
  @Query('SELECT * FROM NoteBook')
  Future<List<NoteBook>> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(NoteBook item);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<NoteBook> item);
}
