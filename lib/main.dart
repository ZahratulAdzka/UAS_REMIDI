import 'package:flutter/material.dart';
import 'package:modul_4/screens/money_tracker_screen.dart'; // Ganti dengan MoneyTrackerScreen

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      title: 'Money Tracker App', // Ganti dengan nama aplikasi yang relevan
      theme: ThemeData(
        primarySwatch: Colors.teal, // Tema hijau/biru untuk aplikasi keuangan
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MoneyTrackerScreen(), // Halaman utama Money Tracker
    );
  }
}


// ZAHDRATUL ADZKA NAFISA HAFIZH
// NIM: 24060121140165
//PEMBER D
// KAK RAKHA