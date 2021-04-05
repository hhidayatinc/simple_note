import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 50), 
          children: <Widget>[
      ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.collections_bookmark, color: Colors.white,),
          backgroundColor: Colors.yellow[700]),
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
    ]));
  }
}