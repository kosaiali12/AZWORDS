import 'dart:async';

import 'package:azwords/Function/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WordsDatabase {
  static final WordsDatabase instance = WordsDatabase._init();

  static Database? _database;

  WordsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('words.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _creatDB);
  }

  Future _creatDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableNote (
  ${NoteFeild.word} TEXT NOT NULL,
  ${NoteFeild.meanings} TEXT NOT NULL,
  ${NoteFeild.date} TEXT NOT NULL,
  ${NoteFeild.fav} INTEGER NOT NULL
)
''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future create(Word word) async {
    final db = await instance.database;
    Map<String, dynamic> d = word.toJson();
    print(d[NoteFeild.date]);
    final id = await db.insert(tableNote, d);
    Word w = await readWord(d[NoteFeild.word]);
    print(w.date);
  }

  Future<Word> readWord(String word) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNote,
      columns: NoteFeild.values,
      where: '${NoteFeild.word} = ?',
      whereArgs: [word],
    );
    print(maps.first[NoteFeild.meanings] as String);
    if (maps.isNotEmpty && maps.first[NoteFeild.date] != null) {
      return Word.fromJson(maps.first);
    } else {
      throw Exception('Word $word was not found');
    }
  }

  Future<List<Word>> search(String word) async {
    final db = await instance.database;

    final maps = await db.rawQuery(
        'SELECT * FROM $tableNote WHERE ${NoteFeild.word} LIKE "%$word%" ');
    return maps.map((json) => Word.fromJson(json)).toList();
  }

  Future updateFav(Word word) async {
    final db = await instance.database;
    db.update(tableNote, word.toJson(),
        where: '${NoteFeild.word} = ?', whereArgs: [word.word]);
  }

  Future deletWord(String words) async {
    final db = await instance.database;

    await db.delete(
      tableNote,
      where: '${NoteFeild.word} = ?',
      whereArgs: [words],
    );
  }

  Future<List<Word>> readAllWords() async {
    final db = await instance.database;
    final maps = await db.query(tableNote);

    return maps.map((json) => Word.fromJson(json)).toList();
  }
}
