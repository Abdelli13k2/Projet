import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class TaskRepository {
  final Database database;

  TaskRepository({required this.database});

  /// CREATE
  Future<int> create(Task task) async {
    return await database.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// READ (by id)
  Future<Task?> read(int id) async {
    final maps = await database.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Task.fromMap(maps.first);
  }

  /// READ ALL
  Future<List<Task>> readAll() async {
    final result = await database.query('tasks');

    return result.map((map) => Task.fromMap(map)).toList();
  }

  /// UPDATE
  Future<int> update(Task task) async {
    return await database.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// DELETE
  Future<int> delete(int id) async {
    return await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// COUNT
  Future<int> count() async {
    final result =
        await database.rawQuery('SELECT COUNT(*) as count FROM tasks');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// MAX ID
  Future<int> getMaxId() async {
    final result =
        await database.rawQuery('SELECT MAX(id) as maxId FROM tasks');

    final value = result.first['maxId'];

    if (value == null) return 0;

    return value as int;
  }
}
