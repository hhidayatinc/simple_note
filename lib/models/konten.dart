class Konten {
  int _id;
  String _kategori;
  String _title;
  String _note;
  String _date;

//getter akan mengambil nilai yang dimasukkan ke consturctor dan setter ini akan dipakai untuk 
//mengembalikan nilai yang dimasukkan dari constructor, untuk setiap variable.
//
  get id => this._id;
  set id(int value) => this._id = value;

  String get kategori => this._kategori;
  set kategori(value) => this._kategori = value;

  String get title => this._title;
  set title(String title) => this._title = title;

  get note => this._note;
  set note(String note) => this._note = note;

  get date => this._date;
  set date(String date) => this._date = date;

//konstruktor 1
  Konten(this._kategori, this._date, this._title, this._note);

//kontructor kedua adalah berbentuk map digunakan untuk mengambil data dari sql yang 
//tersimpan berbentuk Map setelah itu akan disimpan kembali dalam bentuk variabel
  Konten.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._kategori = map['kategori'];
    this._date = map['date'];
    this._title = map['title'];
    this._note = map['note'];
  }
//method Map untuk melakukan update dan insert.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['kategori'] = this._kategori;
    map['date'] = this._date;
    map['title'] = this._title;
    map['note'] = this._note;
    return map;
  }
}
