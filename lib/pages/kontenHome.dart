import 'package:flutter/material.dart';
import 'package:new_note/helper/dbHelper.dart';
import 'package:new_note/models/konten.dart';
import 'package:sqflite/sqflite.dart';
import 'kontenForm.dart';
import 'mainDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Konten> kontenList;
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Simple Note"), backgroundColor: Colors.lightBlue[900]),
      body: Column(
        children: [
          Expanded(
            child: createListView(),
          ),
          Container(
              padding: EdgeInsets.only(left: 250, bottom: 30),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                backgroundColor: Colors.yellow[700],
                onPressed: () async {
                  var konten = await navigateToEntryForm(context, null);
                  if (konten != null) {
                    int result = await dbHelper.insertKonten(konten);
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

  Future<Konten> navigateToEntryForm(
      BuildContext context, Konten konten) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return KontenForm(konten);
    }));
    return result;
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //select data
      Future<List<Konten>> kontenListFuture = dbHelper.getKontenList();
      kontenListFuture.then((kontenList) {
        setState(() {
          this.kontenList = kontenList;
          this.count = kontenList.length;
        });
      });
    });
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
                  child: Icon(Icons.bookmarks, color: Colors.white,)),
              title: Row(children: [
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    this.kontenList[index].kategori + " -",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    this.kontenList[index].title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      this.kontenList[index].date,
                      style:
                          TextStyle(fontSize: 10),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      this.kontenList[index].note,
                      style:
                          TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () async {
                  dbHelper.deleteKonten(kontenList[index].id);
                  updateListView();
                },
              ),
              onTap: () async {
                var konten = await navigateToEntryForm(
                    context, this.kontenList[index]);
                if (konten != null) dbHelper.updateKonten(konten);
                updateListView();
              },
            ),
          );
        });
  }
}
