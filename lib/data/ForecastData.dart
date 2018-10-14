import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_application/data/WeatherData.dart';
class ForecastData {
  // Weather main
  final List forecastList;

  ForecastData({this.forecastList});

  factory ForecastData.fromJson(Map<String, dynamic> value) {
    List list = new List();
    for (dynamic e in value['list']) {
      WeatherData w = new WeatherData(
        dateTime: e['dt'],
        realTime: new DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000, isUtc: false),
        cityName: value['city']['name'],
        weatherTemp: e['main']['temp'].toDouble(),
        weatherDesc: e['weather'][0]['main'],
        icon: e['weather'][0]['icon'],
      );
      list.add(w);
    }
    return ForecastData(
      forecastList: list,
    );
  }


}