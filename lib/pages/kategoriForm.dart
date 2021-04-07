import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_note/models/kategori.dart';

class KategoriForm extends StatefulWidget {
  final Kategori kategori;
  KategoriForm(this.kategori);

  @override
  KategoriFormState createState() => KategoriFormState(this.kategori);
}

class KategoriFormState extends State<KategoriForm> {
  Kategori kategori;
  KategoriFormState(this.kategori);
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (kategori != null) {
      titleController.text = kategori.title;
      descController.text = kategori.desc;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: kategori == null ? Text('Add Category') : Text('Edit Category'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: TextField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Category Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: TextField(
              controller: descController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Category Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {},
            ),
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
                    if (kategori == null) {
                      // tambah data
                      kategori =
                          Kategori(titleController.text, descController.text);
                    } else {
                      // ubah data
                      kategori.title = titleController.text;
                      kategori.desc = descController.text;
                    }
                    // kembali ke layar sebelumnya dengan membawa objek item
                    Navigator.pop(context, kategori);
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
                  textColor:  Colors.white,
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
          ),
        ]),
      ),
    );
  }
}
