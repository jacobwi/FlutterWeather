import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherData{

  // Coords
  double lon;
  double lat;

  // Weather Desc
  int id;
  String weather;
  String weatherDesc;

  // Weather main
  double weatherTemp;
  double weatherHumidity;

  String cityName;
  int dateTime;
  WeatherData({this.lon, this.lat, this.id, this.weather, this.weatherDesc,
      this.weatherTemp, this.weatherHumidity, this.cityName, this.dateTime});

  factory WeatherData.fromJson(Map<String, dynamic> value) {

    return WeatherData(
        lon: value['coord']['lon'].toDouble(),
        lat: value['coord']['lat'].toDouble(),
        id: value['weather'][0]['id'],
        weather: value['weather'][0]['main'],
        weatherDesc: value['weather'][0]['description'],
        weatherTemp: value['main']['temp'].toDouble(),
        weatherHumidity: value['main']['humidity'].toDouble(),
        cityName: value['name'],
        dateTime: value['dt']
    );
  }
  
}