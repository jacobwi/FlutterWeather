import 'package:flutter/material.dart';
import 'package:weather_application/ui/res.dart';
import 'package:weather_application/data/WeatherData.dart';
import 'package:intl/intl.dart';
class WeatherItem extends StatelessWidget {
  final WeatherData data;
  WeatherItem({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityTime = new DateTime.fromMillisecondsSinceEpoch(data.dateTime);
    final f = new DateFormat("hh:mm a");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Text(data.cityName, style: TextStyle(
          color: $res.tempColors,
          fontSize: 23.0,
          fontWeight: FontWeight.w500,
        )),
        new Text(
            '${data.weatherDesc[0].toUpperCase()}${data.weatherDesc.substring(
                1)}',
            style: TextStyle(
              color: $res.tempColors,
              fontSize: 19.0,
              fontWeight: FontWeight.w500,
            )
        ),
        new Text(data.weatherTemp.toString().split(
            ".")[0] + "°", style: TextStyle(
          color: $res.tempColors,
          fontSize: 70.0,
          fontWeight: FontWeight.w500,
        )),
        new Text(f.format(cityTime),
            style: TextStyle(
          color: $res.tempColors,
          fontSize: 12.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ))
      ],
    );
  }

}