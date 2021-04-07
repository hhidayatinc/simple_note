import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_note/helper/dbHelper.dart';
import 'package:new_note/models/kategori.dart';
import 'package:new_note/models/konten.dart';
import 'package:sqflite/sqflite.dart';

class KontenForm extends StatefulWidget {
  final Konten konten;
  KontenForm(this.konten);
  @override
  KontenFormState createState() => KontenFormState(this.konten);
}

class KontenFormState extends State<KontenForm> {
  Konten konten;
  Kategori kategori;
  DbHelper dbHelper = DbHelper();
  KontenFormState(this.konten);
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  DateTime _chooseDate = DateTime.now();
  List<Kategori> kategoriList = List<Kategori>();
  List<String> listKategori = List<String>();

  int indexList = 0;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //select data
      Future<List<Kategori>> kategoriListFuture = dbHelper.getKategoriList();
      kategoriListFuture.then((kategoriList) {
        setState(() {
          for (int i = 0; i < kategoriList.length; i++) {
            listKategori.add(kategoriList[i].title);
          }
        });
      });
    });
  }

  Widget build(BuildContext context) {
    if (konten != null) {
      titleController.text = konten.title;
      noteController.text = konten.note;
    }
    return Scaffold(
        appBar: AppBar(
          title: konten == null
              ? Text('Add Note or Wishlist')
              : Text('Edit Note or Wishlist'),
          backgroundColor: Colors.lightBlue[900],
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              Center(
                child: DropdownButton<String>(
                  items: listKategori.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: listKategori[indexList],
                  hint: Text("Choose category"),
                  onChanged: (String value) {
                    int i = listKategori.indexOf(value);
                    setState(() {
                      indexList = i;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: noteController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Note Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: DateField(
                    onDateSelected: (DateTime value) {
                      setState(() {
                        _chooseDate = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'Choose Date',
                      icon: Icon(Icons.date_range),
                    ),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    dateFormat: DateFormat.yMd(),
                    selectedDate: _chooseDate),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(children: <Widget>[
                  //tombol simpan
                  Expanded(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Colors.yellow[800],
                      textColor: Colors.white,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (konten == null) {
                          // tambah data
                          konten = Konten(
                              listKategori[indexList].toString(),
                              _chooseDate.toString(),
                              titleController.text,
                              noteController.text);
                        } else {
                          // ubah data
                          konten.kategori = listKategori[indexList].toString();
                          konten.date = _chooseDate.toString();
                          konten.title = titleController.text;
                          konten.note = noteController.text;
                        }
                        // kembali ke layar sebelumnya dengan membawa objek item
                        Navigator.pop(context, konten);
                      },
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  //tombol batal
                  Expanded(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Colors.yellow[800],
                      textColor: Colors.white,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
              )
            ],
          ),
        ));
  }
}
