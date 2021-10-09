import 'package:floor/floor.dart';
import 'package:notebook/database/entity/note.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM Note where deleted = false order by updatedTime desc')
  Future<List<Note>> findAllOrderUpdatedTime();

  @Query('SELECT * FROM Note where deleted = false order by createdTime desc')
  Future<List<Note>> findAllOrderCreatedTime();

  @Query(
      'SELECT * FROM Note where deleted = false and notebookId = :notebookId order by updatedTime desc')
  Future<List<Note>> findByNotebookIdOrderUpdatedTime(String notebookId);

  @Query(
      'SELECT * FROM Note where deleted = false and notebookId = :notebookId order by createdTime desc')
  Future<List<Note>> findByNotebookIdOrderCreatedTime(String notebookId);

  @Query(
      'SELECT * FROM Note where deleted = false and notebookId is null order by updatedTime desc')
  Future<List<Note>> findByNotebookIsNullOrderUpdatedTime();

  @Query(
      'SELECT * FROM Note where deleted = false and notebookId is null order by createdTime desc')
  Future<List<Note>> findByNotebookIsNullOrderCreatedTime();

  @Query('SELECT * FROM Note where deleted = true order by updatedTime desc')
  Future<List<Note>> findByDeleted();

  @Query('SELECT * FROM Note where id = :id')
  Future<Note?> findById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(Note item);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(Note item);

  @Query('delete FROM Note where id = :id')
  Future<void> delete(String id);

  @transaction
  Future<void> deletes(List<String> ids) async {
    ids.forEach((element) {
      this.delete(element);
    });
  }

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<Note> item);
}
