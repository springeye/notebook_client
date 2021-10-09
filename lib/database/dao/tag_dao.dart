import 'package:floor/floor.dart';
import 'package:notebook/database/entity/tag.dart';

@dao
abstract class TagDao {
  @Query('SELECT * FROM Tag')
  Future<List<Tag>> findAll();

  @Query('SELECT * FROM Tag where noteId = :noteId')
  Future<List<Tag>> findByNoteId(String noteId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(Tag item);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<Tag> item);
}
