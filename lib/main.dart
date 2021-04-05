import 'package:flutter/material.dart';
import 'package:new_note/pages/kategoriHome.dart';
import 'pages/kontenHome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/kategori': (context) => KategoriHome(),
      },
    );
  }
}



