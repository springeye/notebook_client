// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NotebookDao? _notebookDaoInstance;

  NoteDao? _noteDaoInstance;

  TagDao? _tagDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Note` (`uuid` TEXT NOT NULL, `notebookId` TEXT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `createdTime` INTEGER NOT NULL, `updatedTime` INTEGER NOT NULL, `deleted` INTEGER NOT NULL, `encrypted` TEXT NOT NULL, `synced` INTEGER NOT NULL, PRIMARY KEY (`uuid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `NoteBook` (`id` TEXT NOT NULL, `pid` TEXT NOT NULL, `title` TEXT NOT NULL, `createdTime` INTEGER NOT NULL, `updatedTime` INTEGER NOT NULL, `deleted` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Tag` (`id` TEXT NOT NULL, `text` TEXT NOT NULL, `createdTime` INTEGER NOT NULL, `updatedTime` INTEGER NOT NULL, `noteId` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NotebookDao get notebookDao {
    return _notebookDaoInstance ??= _$NotebookDao(database, changeListener);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }

  @override
  TagDao get tagDao {
    return _tagDaoInstance ??= _$TagDao(database, changeListener);
  }
}

class _$NotebookDao extends NotebookDao {
  _$NotebookDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _noteBookInsertionAdapter = InsertionAdapter(
            database,
            'NoteBook',
            (NoteBook item) => <String, Object?>{
                  'id': item.id,
                  'pid': item.pid,
                  'title': item.title,
                  'createdTime': _dateTimeConverter.encode(item.createdTime),
                  'updatedTime': _dateTimeConverter.encode(item.updatedTime),
                  'deleted': item.deleted ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NoteBook> _noteBookInsertionAdapter;

  @override
  Future<List<NoteBook>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM NoteBook',
        mapper: (Map<String, Object?> row) => NoteBook(
            row['id'] as String, row['pid'] as String, row['title'] as String));
  }

  @override
  Future<void> insert(NoteBook item) async {
    await _noteBookInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<NoteBook> item) async {
    await _noteBookInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _noteInsertionAdapter = InsertionAdapter(
            database,
            'Note',
            (Note item) => <String, Object?>{
                  'uuid': item.uuid,
                  'notebookId': item.notebookId,
                  'title': item.title,
                  'content': item.content,
                  'createdTime': _dateTimeConverter.encode(item.createdTime),
                  'updatedTime': _dateTimeConverter.encode(item.updatedTime),
                  'deleted': item.deleted ? 1 : 0,
                  'encrypted': item.encrypted,
                  'synced': item.synced ? 1 : 0
                }),
        _noteUpdateAdapter = UpdateAdapter(
            database,
            'Note',
            ['uuid'],
            (Note item) => <String, Object?>{
                  'uuid': item.uuid,
                  'notebookId': item.notebookId,
                  'title': item.title,
                  'content': item.content,
                  'createdTime': _dateTimeConverter.encode(item.createdTime),
                  'updatedTime': _dateTimeConverter.encode(item.updatedTime),
                  'deleted': item.deleted ? 1 : 0,
                  'encrypted': item.encrypted,
                  'synced': item.synced ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final UpdateAdapter<Note> _noteUpdateAdapter;

  @override
  Future<List<Note>> findAllOrderUpdatedTime() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note where deleted = false order by updatedTime desc',
        mapper: (Map<String, Object?> row) => Note(
            row['uuid'] as String,
            row['notebookId'] as String?,
            row['title'] as String,
            row['content'] as String,
            _dateTimeConverter.decode(row['createdTime'] as int),
            _dateTimeConverter.decode(row['updatedTime'] as int),
            (row['deleted'] as int) != 0,
            row['encrypted'] as String,
            (row['synced'] as int) != 0));
  }

  @override
  Future<List<Note>> findAllOrderCreatedTime() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note where deleted = false order by createdTime desc',
        mapper: (Map<String, Object?> row) => Note(
            row['uuid'] as String,
            row['notebookId'] as String?,
            row['title'] as String,
            row['content'] as String,
            _dateTimeConverter.decode(row['createdTime'] as int),
            _dateTimeConverter.decode(row['updatedTime'] as int),
            (row['deleted'] as int) != 0,
            row['encrypted'] as String,
            (row['synced'] as int) != 0));
  }

  @override
  Future<List<Note>> findByNotebookIdOrderUpdatedTime(String notebookId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note where deleted = false and notebookId = ?1 order by updatedTime desc',
        mapper: (Map<String, Object?> row) => Note(row['uuid'] as String, row['notebookId'] as String?, row['title'] as String, row['content'] as String, _dateTimeConverter.decode(row['createdTime'] as int), _dateTimeConverter.decode(row['updatedTime'] as int), (row['deleted'] as int) != 0, row['encrypted'] as String, (row['synced'] as int) != 0),
        arguments: [notebookId]);
  }

  @override
  Future<List<Note>> findByNotebookIdOrderCreatedTime(String notebookId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note where deleted = false and notebookId = ?1 order by createdTime desc',
        mapper: (Map<String, Object?> row) => Note(row['uuid'] as String, row['notebookId'] as String?, row['title'] as String, row['content'] as String, _dateTimeConverter.decode(row['createdTime'] as int), _dateTimeConverter.decode(row['updatedTime'] as int), (row['deleted'] as int) != 0, row['encrypted'] as String, (row['synced'] as int) != 0),
        arguments: [notebookId]);
  }

  @override
  Future<List<Note>> findByNotebookIsNullOrderUpdatedTime() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note where deleted = false and notebookId is null order by updatedTime desc',
        mapper: (Map<String, Object?> row) => Note(
            row['uuid'] as String,
            row['notebookId'] as String?,
            row['title'] as String,
            row['content'] as String,
            _dateTimeConverter.decode(row['createdTime'] as int),
            _dateTimeConverter.decode(row['updatedTime'] as int),
            (row['deleted'] as int) != 0,
            row['encrypted'] as String,
            (row['synced'] as int) != 0));
  }

  @override
  Future<List<Note>> findByNotebookIsNullOrderCreatedTime() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note where deleted = false and notebookId is null order by createdTime desc',
        mapper: (Map<String, Object?> row) => Note(
            row['uuid'] as String,
            row['notebookId'] as String?,
            row['title'] as String,
            row['content'] as String,
            _dateTimeConverter.decode(row['createdTime'] as int),
            _dateTimeConverter.decode(row['updatedTime'] as int),
            (row['deleted'] as int) != 0,
            row['encrypted'] as String,
            (row['synced'] as int) != 0));
  }

  @override
  Future<List<Note>> findByDeleted() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Note where deleted = true order by updatedTime desc',
        mapper: (Map<String, Object?> row) => Note(
            row['uuid'] as String,
            row['notebookId'] as String?,
            row['title'] as String,
            row['content'] as String,
            _dateTimeConverter.decode(row['createdTime'] as int),
            _dateTimeConverter.decode(row['updatedTime'] as int),
            (row['deleted'] as int) != 0,
            row['encrypted'] as String,
            (row['synced'] as int) != 0));
  }

  @override
  Future<Note?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM Note where id = ?1',
        mapper: (Map<String, Object?> row) => Note(
            row['uuid'] as String,
            row['notebookId'] as String?,
            row['title'] as String,
            row['content'] as String,
            _dateTimeConverter.decode(row['createdTime'] as int),
            _dateTimeConverter.decode(row['updatedTime'] as int),
            (row['deleted'] as int) != 0,
            row['encrypted'] as String,
            (row['synced'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> delete(String id) async {
    await _queryAdapter
        .queryNoReturn('delete FROM Note where id = ?1', arguments: [id]);
  }

  @override
  Future<void> insert(Note item) async {
    await _noteInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<Note> item) async {
    await _noteInsertionAdapter.insertList(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> update(Note item) async {
    await _noteUpdateAdapter.update(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deletes(List<String> ids) async {
    if (database is sqflite.Transaction) {
      await super.deletes(ids);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.noteDao.deletes(ids);
      });
    }
  }
}

class _$TagDao extends TagDao {
  _$TagDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tagInsertionAdapter = InsertionAdapter(
            database,
            'Tag',
            (Tag item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'createdTime': _dateTimeConverter.encode(item.createdTime),
                  'updatedTime': _dateTimeConverter.encode(item.updatedTime),
                  'noteId': item.noteId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tag> _tagInsertionAdapter;

  @override
  Future<List<Tag>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Tag',
        mapper: (Map<String, Object?> row) =>
            Tag(row['id'] as String, row['text'] as String));
  }

  @override
  Future<List<Tag>> findByNoteId(String noteId) async {
    return _queryAdapter.queryList('SELECT * FROM Tag where noteId = ?1',
        mapper: (Map<String, Object?> row) =>
            Tag(row['id'] as String, row['text'] as String),
        arguments: [noteId]);
  }

  @override
  Future<void> insert(Tag item) async {
    await _tagInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<Tag> item) async {
    await _tagInsertionAdapter.insertList(item, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _stringArrayConvert = StringArrayConvert();
final _dateTimeConverter = DateTimeConverter();
