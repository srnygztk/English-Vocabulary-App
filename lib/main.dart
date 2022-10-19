import 'package:flutter/material.dart';
import 'package:tez/pages/lists.dart';
import 'package:tez/pages/temprory.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);


    return MaterialApp(
      routes: {
        '/lists':(context)=>const ListsPage()
      },
      debugShowCheckedModeBanner: false,
      title: 'Kelime Ezbelerleme Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TemproryPage(),
    );
  }
}


