import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_note/models/konten.dart';

class KontenForm extends StatefulWidget {
  final Konten konten;
  KontenForm(this.konten);
  @override
  KontenFormState createState() => KontenFormState(this.konten);
}

class KontenFormState extends State<KontenForm> {
  Konten konten;
  KontenFormState(this.konten);
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();

  DateTime _chooseDate = DateTime.now();
  List<DropdownMenuItem> _listKategori = [];
  var _valueKategori;

  @override
  Widget build(BuildContext context) {
    if (konten != null) {
      titleController.text = konten.title;
      noteController.text = konten.note;
      kategoriController.text = konten.kategori;
      //kategoriController.text = konten.idKategori.toString();
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          title: konten == null ? Text('Add Note') : Text('Edit Note'),
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
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: TextField(
                  controller: kategoriController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
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
              // harga
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
              //stok
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
                // ignore: deprecated_member_use
              ),
//button
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(children: <Widget>[
                  //tombol simpan
                  Expanded(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Colors.lightBlue[900],
                      textColor: Colors.white,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.2,
                      ),
                      onPressed: () {
                        if (konten == null) {
                          // tambah data
                          konten = Konten(
                              kategoriController.text,
                              _chooseDate.toString(),
                              titleController.text,
                              noteController.text);
                        } else {
                          // ubah data
                          konten.kategori = kategoriController.text;
                          konten.date = _chooseDate.toString();
                          konten.title = titleController.text;
                          konten.note = noteController.text;
                        }
                        // kembali ke layar sebelumnya dengan membawa objek item
                        Navigator.pop(context,konten);
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
                      color: Colors.lightBlue[900],
                      textColor: Colors.white,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.2,
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
