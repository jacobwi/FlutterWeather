import 'package:flutter/material.dart';
import 'package:weather_application/ui/res.dart';
import 'package:weather_application/data/WeatherData.dart';
import 'package:weather_application/ui/Weather.dart';
import 'package:intl/intl.dart';
class WeatherItem extends StatelessWidget {
  final WeatherData data;
  WeatherItem({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(data.dateTime * 1000);
    var format = new DateFormat.jm();
    var dateString = format.format(date);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(data.cityName, style: TextStyle(
            color: Weather.dynamicFontColor,
            fontSize: 23.0,
            fontWeight: FontWeight.w500,
          )),
          new Text(
              '${data.weatherDesc[0].toUpperCase()}${data.weatherDesc.substring(
                  1)}',
              style: TextStyle(
                color: Weather.dynamicFontColor,
                fontSize: 19.0,
                fontWeight: FontWeight.w500,
              )
          ),
          new Text(data.weatherTemp.toString().split(
              ".")[0] + "°", style: TextStyle(
            color: Weather.dynamicFontColor,
            fontSize: 70.0,
            fontWeight: FontWeight.w500,
          )),
          new Text(dateString,
              style: TextStyle(
            color: Weather.dynamicFontColor,
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            )
          ),
        ],
      ),
    );
  }
}