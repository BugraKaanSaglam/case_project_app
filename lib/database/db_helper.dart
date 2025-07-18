// ignore_for_file: depend_on_referenced_packages

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'case_database.dart';

// DB helper
class DBHelper {
  static Database? _dbInstance;

  // get DB instance
  Future<Database> get _db async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initDb();
    return _dbInstance!;
  }

  // initialize DB
  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'kvquizdatabase_v3.db');
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  // create table
  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE caseTable(
        Ver INTEGER PRIMARY KEY,
        LoginEmail TEXT NOT NULL,
        LoginSifre TEXT NOT NULL,
        IsRememberLogin INTEGER NOT NULL,
        Language TEXT NOT NULL
      )
    ''');
  }

  // insert or replace record
  Future<void> insertOrReplace(CaseDatabase item) async {
    final db = await _db;
    await db.insert('caseTable', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // get record by ver
  Future<CaseDatabase?> getByVer(int ver) async {
    final db = await _db;
    final results = await db.query('caseTable', where: 'Ver = ?', whereArgs: [ver]);
    if (results.isNotEmpty) {
      return CaseDatabase.fromMap(results.first);
    }
    return null;
  }

  // update record
  Future<int> update(CaseDatabase item) async {
    final db = await _db;
    return await db.update('caseTable', item.toMap(), where: 'Ver = ?', whereArgs: [item.ver]);
  }

  // delete record
  Future<int> delete(int ver) async {
    final db = await _db;
    return await db.delete('caseTable', where: 'Ver = ?', whereArgs: [ver]);
  }

  // close DB
  Future<void> close() async {
    final db = await _db;
    await db.close();
    _dbInstance = null;
  }
}
