import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/data/WeatherData.dart';
import 'package:weather_application/ui/Weather.dart';
class ForecastItem extends StatelessWidget {
  final WeatherData data;

  ForecastItem({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network('https://openweathermap.org/img/w/${data.icon}.png'),
            Text(data.cityName, style: new TextStyle(color: Weather.dynamicFontColor)),
            Text(data.weatherDesc, style: new TextStyle(color: Weather.dynamicFontColor, fontSize: 24.0)),
            Text('${data.weatherTemp.toString().split(
                ".")[0] + "°"}F',  style: new TextStyle(color: Weather.dynamicFontColor)),
            Text(new DateFormat.yMMMd().format(data.realTime), style: new TextStyle(color: Weather.dynamicFontColor)),
            Text(new DateFormat.jm().format(data.realTime), style: new TextStyle(color: Weather.dynamicFontColor)),
          ],
        ),
      ),
    );
  }
}