import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_note/helper/dbHelper.dart';
import 'package:new_note/models/kategori.dart';
import 'package:new_note/pages/mainDrawer.dart';
import 'package:sqflite/sqflite.dart';
import 'kategoriForm.dart';

class KategoriHome extends StatefulWidget {
  @override
  KategoriHomeState createState() => KategoriHomeState();
}

class KategoriHomeState extends State<KategoriHome> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Kategori> kategoriList;

  @override
  void initState() {
    super.initState();
    updateListView();
  }
  Widget build(BuildContext context) {
    if (kategoriList == null) {
      // ignore: deprecated_member_use
      kategoriList = List<Kategori>();
    }
    return Scaffold(
      appBar: AppBar(
          title: Text("List Kategori"), backgroundColor: Colors.lightBlue[900]),
      body: Column(
        children: [
          Expanded(
            child: createListView(),
          ),
          Container(
             padding: EdgeInsets.only(left: 250, bottom: 30),
              child: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Colors.yellow[800],
            onPressed: () async {
              var kategori = await navigateToEntryForm(context, null);
              if (kategori != null) {
                int result = await dbHelper.insertKategori(kategori);
                    if (result > 0) {
                      updateListView();
              }
              }
            },
          ))
        ],
      ),
      drawer: MainDrawer(),
    );
  }

  Future<Kategori> navigateToEntryForm(
      BuildContext context, Kategori kategori) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return KategoriForm(kategori);
    }));
    return result;
  }

  ListView createListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (buildContext, int index) {
          return Card(
            color: Colors.white,
            elevation: 3.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.yellow[800],
                child: Icon(Icons.category, color: Colors.white,),
              ),
              title: Container(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  this.kategoriList[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      this.kategoriList[index].desc,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () async {
                  dbHelper.deleteKategori(kategoriList[index].id);
                  updateListView();
                },
              ),
              onTap: () async {
                var kategori = await navigateToEntryForm(
                    context, this.kategoriList[index]);
                if (kategori != null) dbHelper.updateKategori(kategori);
                updateListView();
              },
            ),
          );
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //select data
      Future<List<Kategori>> kategoriListFuture = dbHelper.getKategoriList();
      kategoriListFuture.then((kategoriList) {
        setState(() {
          this.kategoriList = kategoriList;
          this.count = kategoriList.length;
        });
      });
    });
  }
}
