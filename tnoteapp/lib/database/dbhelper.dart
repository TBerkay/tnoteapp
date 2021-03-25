import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tnoteapp/models/note.dart';

class DbHelper {

  static DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper(){
    return _dbHelper;
  }

  String id = "id";
  String title = "title";
  String description = "description";
  String date = "date";

  Database _db;

  Future<Database> get db async{

    if(_db==null){
      _db = await initializeDb();
    }

    return _db;
  }

  Future<Database> initializeDb() async{
    String path = join(await getDatabasesPath(), "note2.db");
    var dbNotes = openDatabase(path, version: 1, onCreate: _onCreate);
    return dbNotes;
  }

  Future<void> _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE notes($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $description TEXT, $date TEXT )");
  }

  Future<List<Note>> getAll() async{
    Database client = await this.db;
    var result = await client.query("notes");
    return List.generate(result.length, (index) {
      return Note.fromObject(result[index]);
    });
  }

  Future<int> insert(Note note) async{
    Database client = await this.db;
    var result = await client.insert("notes", note.toMap());
    return result;
  }

  Future<int> update(Note note) async{
    Database client = await this.db;
    var result = await client.update("notes", note.toMap(), where: "id=?", whereArgs: [note.id]);
    return result;
  }

  Future<int> delete(int id) async{
    Database client = await this.db;
    var result = await client.delete("notes", where: "id=?", whereArgs: [id]);
    return result;
  }

}