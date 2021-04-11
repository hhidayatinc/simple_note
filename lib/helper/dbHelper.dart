import 'dart:io';
import 'package:new_note/models/kategori.dart';
import 'package:new_note/models/konten.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  static DbHelper _dbHelper;
  static Database _database;
  Kategori kategori;
  Konten konten;

  DbHelper._createObject();
  
  Future<Database> initDb() async {
//Method getApplicationDocumentsDirectory() berfungsi untuk mengambil direktori folder aplikasi 
//untuk menempatkan data yang dibuat pengguna sehingga tidak dapat dibuat ulang oleh aplikasi 
//tersebut. Setelah itu kita gunakan variable String path, untuk membuat nama database kita 
//dengan mengambil lokasi directory nya dan menambahkannya dengan nama database item.db
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'simpleNote.db';

    var itemDatabase = openDatabase(path,
        version: 5, onCreate: _createDb);
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
        kategori TEXT,
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
  //Variable count digunakan untuk menampung hasil SQL — nya. Bertipe Integer karena ketika sistem berhasil 
//dieksekusi, nilai yang dikeluarkan adalah 1.
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
  Future<int> deleteKategori(int id, String kategori) async {
    Database db = await this.initDb();
    int count = await db.delete('kategori', where: 'id=?', whereArgs: [id]);
  
    int count1 = await db.delete('konten', where: 'kategori=?', whereArgs: [kategori]);
    
    
    return count;
  }
    // if(kategori.id.toString() == null){
    //   int count1 = await db.delete('konten', where: 'title=?', whereArgs: [title]);
    // }
    //await db.execute('DELETE a*, b* FROM kategori a, konten b WHERE a.title=b.title');

//Future adalah “tipe data” yang terpanggil dengan adanya delay atau “keterlambatan”. 
//sistem akan terus menjalankan method tersebut sampai method itu selesai berjalan.
// Contohnya ketika kita akan mengambil data yang ada di dalam database/API 
//kita membutuhkan method Future untuk mengambil data di dalam database/API tersebut.
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
//future selalu pakai async sehingga sistem menunggu sampai terjadi blocking
  Future<List<Kategori>> getKategoriList() async {
    var itemMapList = await selectKategori();//await digunakan didalam method yg menerapkan async
    int count = itemMapList.length;         //jika method menggunakan await, maka harus
    // ignore: deprecated_member_use           //menunggu sampe selese
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