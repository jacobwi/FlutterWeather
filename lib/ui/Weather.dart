import 'package:flutter/material.dart';
import 'package:weather_application/data/WeatherData.dart';
import 'package:weather_application/data/ForecastData.dart';
import 'package:weather_application/network/Api.dart';
import 'package:weather_application/ui/ForecastItem.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_application/ui/res.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:weather_application/ui/WeatherItem.dart';
import 'package:intl/intl.dart';
String zipCode = "03102";

class Weather extends StatefulWidget {
  static Color dynamicFontColor;
  @override
  State<StatefulWidget> createState() {
    return new _WeatherState();
  }

}


class _WeatherState extends State<Weather> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSub;
  final myController = new TextEditingController();
  WeatherData weatherData;
  ForecastData forecastData;
  bool isLoading = false;
  Location location;

  String img="";
  int dataTime;
  Color themeColor;
  @override
  void initState() {
    super.initState();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    fetchData();
  }

  fetchData() async {
    dataTime = 0;
    setState(() {
      isLoading = true;
    });

    final respone = await http.get("http://api.openweathermap.org/data/2.5/weather?zip=$zipCode,us&APPID=" + Api.apiCode);
    final respone_forecast = await http.get("http://api.openweathermap.org/data/2.5/forecast?zip=$zipCode&appid=" + Api.apiCode);
    if (respone.statusCode == 200 && respone_forecast.statusCode == 200) {
      var result = json.decode(respone.body);
      var result_forecast = json.decode(respone_forecast.body);
      return setState(() {
        weatherData = new WeatherData.fromJson(result);
        forecastData = new ForecastData.fromJson(result_forecast);
        dataTime = weatherData.dateTime;
        refreshWeather();
        setBackgroundImage();
        isLoading = false;
      });
    }
    else {
      setState(() {
        isLoading = false;
      });
      throw ("Loading data   ");
    }


  }

  fetchDataFromCoords() async {
    dataTime = 0;
    setState(() {
      isLoading = true;
    });
    double lat = currentLocation['latitude'];
    double lon = currentLocation['longitude'];
    final respone = await http.get("http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&APPID=" + Api.apiCode);
    if (respone.statusCode == 200) {
      var result = json.decode(respone.body);
      return setState(() {
        weatherData = new WeatherData.fromJson(result);
        dataTime = weatherData.dateTime;
        refreshWeather();
        setBackgroundImage();
        isLoading = false;
      });
    }
    else {
      setState(() {
        isLoading = false;
      });
      throw ("Loading data   ");
    }


  }
  void setBackgroundImage() async {
    final cityTime = new DateTime.fromMillisecondsSinceEpoch((dataTime * 1000));
    if (cityTime != null) {
      final hour = new DateFormat ("H");
      final amOrPm = new DateFormat("a");
      print(hour.format(cityTime));
      print(amOrPm.format(cityTime).trim());

      if (amOrPm.format(cityTime).trim() == "PM") {
        if (int.parse(hour.format(cityTime)) < 17 ) {
          setState(() {
            img = $img.afternoon;
            print("afternoon");
            Weather.dynamicFontColor = Color(0xFFFFFFFF);
          });

        }
        else {
          setState(() {
            img = $img.night;
            print("night");
            Weather.dynamicFontColor = Color(0xFFFFFFFF);
          });
        }
      }
      else {
        setState(() {
          img = $img.morning;
          Weather.dynamicFontColor = Color(0xDD595877);
        });


      }
    }

  }
  submitData(String zip) {
    if (!zip.isEmpty) {
      fetchData();
    }
  }

  refreshWeather() {
    return weatherData != null ? WeatherItem(data: weatherData) : Container();
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Material(


      child: new Container(
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(img.isEmpty ? $img.defaultImg: img),
                fit: BoxFit.cover)
        ),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(40.0),
                child: Theme(data: ThemeData(
                    hintColor: Colors.grey,
                    primarySwatch: Colors.grey
                ),
                  child: TextField(
                    controller: myController,
                    onChanged: (String e) {
                      setState(() {
                        zipCode = e;
                      });
                    },
                    onSubmitted: submitData,
                    decoration: new InputDecoration(
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: $res.tempColors,
                        ),
                        suffixIcon: new IconButton(
                          icon: new Icon(Icons.gps_fixed),
                          color: Colors.black,
                          onPressed: () { setState(() {
                            location = new Location();
                            initPlatformState();
                            if(currentLocation['latitude'] != 0.0 || currentLocation['longitude'] != 0.0) {
                              fetchDataFromCoords();
                              print(currentLocation['latitude'].toString());
                            }
                          }); },
                        ),
                        filled: true,
                        fillColor: Colors.grey,
                        hintText: "Enter zipcode...",
                        hintStyle: TextStyle(
                            color: $res.tempColors
                        )
                    ),
                    keyboardType: TextInputType.number,
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: refreshWeather(),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: new EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .18),
              child: new Container(
                  height: 240.0,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Container(
                      color: Colors.transparent,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: forecastData != null ? ListView.builder(
                                itemCount: forecastData.forecastList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => ForecastItem(data: forecastData.forecastList.elementAt(index))
                            ) : Container(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initPlatformState() async {
    Map<String, double> myLocation;

    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      myLocation = null;
    }
    setState(() {
      currentLocation = myLocation;
    });
  }




}
