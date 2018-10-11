import 'package:flutter/material.dart';
import 'package:weather_application/ui/HomePage.dart';
import 'package:weather_application/data/WeatherData.dart';
import 'package:weather_application/network/Api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_application/ui/res.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:weather_application/ui/WeatherItem.dart';
import 'package:intl/intl.dart';
class Weather extends State<HomePage> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSub;
  final myController = new TextEditingController();
  WeatherData weatherData;
  bool isLoading = false;
  Location location;
  String zipCode = "03301";
  String img="";
  static Color dynamicFontColor;
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
    setState(() {
      isLoading = true;
    });

    final respone = await http.get("http://api.openweathermap.org/data/2.5/weather?zip=$zipCode,us&APPID=" + Api.apiCode);
    if (respone.statusCode == 200) {
      var result = json.decode(respone.body);
      return setState(() {
        weatherData = new WeatherData.fromJson(result);
        dataTime = weatherData.dateTime;
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
    final cityTime = new DateTime.fromMicrosecondsSinceEpoch((dataTime * 1000));
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
            dynamicFontColor = Color(0xFFFFFFFF);
          });

        }
        else {
          setState(() {
            img = $img.night;
            print("night");
            dynamicFontColor = Color(0xFFFFFFFF);
          });
        }
      }
      else {
        setState(() {
          img = $img.morning;
          dynamicFontColor = Color(0xDD595877);
        });


      }
    }

  }
  submitData(String zip) {
    if (!zip.isEmpty) {
      fetchData();
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(img.isEmpty ? $img.defaultImg: img), fit:
            BoxFit.cover)
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
              child: weatherData != null ? WeatherItem(data: weatherData) : Container(),
            )
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
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
