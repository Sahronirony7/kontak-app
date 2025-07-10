import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kontak Telepon',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // Menggunakan warna yang lebih sesuai dengan tema
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Menghapus banner debug
         
      ),
      home: HomePage(), // Menggunakan halaman HomePage sebagai tampilan pertama
      routes: {
        // Jika ingin menambahkan halaman baru nanti, bisa menggunakan ini untuk navigasi.
        // '/home': (context) => HomePage(),
        // '/addContact': (context) => AddContactPage(),
      },
    );
  }
}
