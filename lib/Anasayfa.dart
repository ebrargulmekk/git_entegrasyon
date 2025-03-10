import 'package:flutter/material.dart';
import 'ProfilSayfasi.dart';
import 'Ayarlar.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _selectedIndex = 0;

  var sayfaListesi = [Container(),ProfilSayfasi(), Ayarlar()];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anasayfa"),
        backgroundColor: Colors.purple, // AppBar rengi
      ),
      body: sayfaListesi[_selectedIndex], // Seçili sayfayı göster
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Text("Menü", style: TextStyle(color: Colors.white, fontSize:30),),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
            ),
            ListTile(
              leading: Icon(Icons.person_rounded, color: Colors.deepPurple),
              title: Text("Profil" ,style: TextStyle(color: Colors.pink),),
              onTap: () {
                setState(() {
                   _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.deepPurple,),
              title: Text("Ayarlar", style: TextStyle(color: Colors.pink),),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}
