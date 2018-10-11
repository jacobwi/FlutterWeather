import 'package:flutter/material.dart';
import 'package:weather_application/ui/HomePage.dart';
import 'package:weather_application/network/Api.dart';
void main() => runApp(new MyApp());

var theme1 = new ThemeData(
  primarySwatch: Colors.grey,
    fontFamily: 'Dosis'
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    print("created");
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: theme1,
      home: new HomePage(),
    );
  }
}


