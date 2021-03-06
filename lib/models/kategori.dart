class Kategori {
  int _id;
  String _title;
  String _desc;

//getter akan mengambil nilai yang dimasukkan ke consturctor dan setter ini akan dipakai untuk 
//mengembalikan nilai yang dimasukkan dari constructor, untuk setiap variable.
  String get desc => this._desc;
  set desc(String value) => this._desc = value;

  get id => this._id;
  set id(value) => this._id = value;

  String get title => this._title;
  set title(String value) => this._title = value;
//konstruktor 1
  Kategori(this._title, this._desc);

//kontructor kedua adalah berbentuk map digunakan untuk mengambil data dari sql yang 
//tersimpan berbentuk Map setelah itu akan disimpan kembali dalam bentuk variabel
  Kategori.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._desc = map['desc'];
  }

//method Map untuk melakukan update dan insert.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['title'] = this._title;
    map['desc'] = this._desc;
    return map;
  }
}
