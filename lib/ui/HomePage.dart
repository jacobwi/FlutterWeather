import 'package:flutter/material.dart';
import 'package:weather_application/ui/Weather.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Weather(),
            ],
          ),
        ],
    );
  }
}