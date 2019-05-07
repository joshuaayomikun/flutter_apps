import 'package:flutter/material.dart';
import 'package:wakanow_test/screens/search_flight.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      title:'Wakanow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: SearchFlight(),

    );
  }
}