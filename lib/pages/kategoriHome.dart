import 'package:flutter/material.dart';
import 'package:new_note/helper/dbHelper.dart';
import 'package:new_note/models/kategori.dart';
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
            backgroundColor: Colors.lightBlue[900],
            onPressed: () async {
              var konten = await navigateToEntryForm(context, null);
              if (konten != null) {}
            },
          ))
        ],
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.only(top: 50), children: <Widget>[
        ListTile(
          leading: CircleAvatar(backgroundColor: Colors.lightBlue[900]),
          title: Text("Simple Note"),
          subtitle: Text("Help you to remember things"),
        ),
        ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, '/');
            }),
        ListTile(
          leading: Icon(Icons.category),
          title: Text("Kategori"),
          onTap: () {
            Navigator.pushNamed(context, '/kategori');
          },
        ),
      ])),
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
                backgroundColor: Colors.lightBlue[900],
                child: Icon(Icons.notes),
              ),
              title: Container(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  this.kategoriList[index].title + "-",
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
                  dbHelper.deleteKonten(kategoriList[index].id);
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