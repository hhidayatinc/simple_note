import 'dart:io';
import 'package:new_note/models/kategori.dart';
import 'package:new_note/models/konten.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DbHelper{
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();
  
  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'simpleNote.db';

    var itemDatabase = openDatabase(path,
        version: 4, onCreate: _createDb);
    return itemDatabase;
  }

  void _createDb(Database db, int version) async{
    var batchTemp = db.batch();
    // ignore: await_only_futures
    await batchTemp.execute('''
        CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        desc TEXT
        )
     ''');
    // ignore: await_only_futures
    await batchTemp.execute('''
        CREATE TABLE konten (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kategori TEXT NOT NULL,
        date TEXT,
        title TEXT,
        note TEXT
        
        )
     ''');
     batchTemp.commit();

  
  }
//select database
  Future<List<Map<String, dynamic>>> selectKonten() async {
    Database db = await this.initDb();
    var mapList = await db.query('konten');
    return mapList;
  }
   Future<List<Map<String, dynamic>>> selectKategori() async {
    Database db = await this.initDb();
    var mapList = await db.query('kategori', orderBy: 'title');
    return mapList;
  }

  //create databases
  Future<int> insertKonten(Konten object) async {
    Database db = await this.initDb();
    int count = await db.insert('konten', object.toMap());
    return count;
  }
    Future<int> insertKategori(Kategori object) async {
    Database db = await this.initDb();
    int count = await db.insert('kategori', object.toMap());
    return count;
  }

  //update databases
  Future<int> updateKonten(Konten object) async {
    Database db = await this.initDb();
    int count = await db
        .update('konten', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

   Future<int> updateKategori(Kategori object) async {
    Database db = await this.initDb();
    int count = await db
        .update('kategori', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //delete databases
  Future<int> deleteKonten(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('konten', where: 'id=?', whereArgs: [id]);
    return count;
  }
  Future<int> deleteKategori(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('kategori', where: 'id=?', whereArgs: [id]);
    return count;
  }

//
  Future<List<Konten>> getKontenList() async {
    var itemMapList = await selectKonten();
    int count = itemMapList.length;
    // ignore: deprecated_member_use
    List<Konten> itemList = List<Konten>();
    for (int i = 0; i < count; i++) {
      itemList.add(Konten.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  Future<List<Kategori>> getKategoriList() async {
    var itemMapList = await selectKategori();
    int count = itemMapList.length;
    // ignore: deprecated_member_use
    List<Kategori> itemList = List<Kategori>();
    for (int i = 0; i < count; i++) {
      itemList.add(Kategori.fromMap(itemMapList[i]));
    }
    return itemList;
  }
 

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}