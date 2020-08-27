import 'package:flutter/material.dart';
import 'package:tugas_kamus/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}