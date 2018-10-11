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

class Weather extends State<HomePage> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSub;
  final myController = new TextEditingController();
  WeatherData _token;
  Location location = new Location();
  String zipCode = "03301";
  @override
  void initState() {
    super.initState();
    // currentLocation['latitude'] = 0.0;
    // currentLocation['longitude'] = 0.0;

    // initPlatformState();
    // locationSub = location.onLocationChanged().listen((Map<String, double> result) {
      // setState(() {
        //currentLocation = result;
      //}
     // );
   // });
    
  }

  Future<WeatherData> fetchData() async {
    final respone = await http.get("http://api.openweathermap.org/data/2.5/weather?zip=$zipCode,us&APPID=" + Api.apiCode);
    if (respone.statusCode == 200) {
      var result = json.decode(respone.body);
      return WeatherData.fromJson(result);
    }
    else {
      throw ("Loading data   ");
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
            image: DecorationImage(image: AssetImage($img.background), fit:
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
                  filled: true,
                  fillColor: Colors.grey,
                  hintText: "Enter zipcode...",
                ),
                keyboardType: TextInputType.number,
              ),
              )
            ),
            Padding(padding: EdgeInsets.only(),
              child: Column(
                children: <Widget>[
                  new FutureBuilder<WeatherData>(
                      future: fetchData(),
                      builder: (BuildContext context,  AsyncSnapshot<WeatherData> snapshot) {
                        if (snapshot.hasData) {
                          WeatherData data = snapshot.data;
                          final temp = data.weatherTemp.toString().split(
                              ".")[0] + "°";
                          final desc = data.weatherDesc;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(data.cityName, style: TextStyle(
                                color: $res.tempColors,
                                fontSize: 23.0,
                                fontWeight: FontWeight.w500,
                              )),
                              new Text(
                                  '${desc[0].toUpperCase()}${desc.substring(
                                      1)}', style: TextStyle(
                                color: $res.tempColors,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500,
                              )),
                              new Text(temp, style: TextStyle(
                                color: $res.tempColors,
                                fontSize: 70.0,
                                fontWeight: FontWeight.w500,
                              ))
                            ],
                          );
                        }
                        else if (snapshot.hasError) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(snapshot.error),
                              SizedBox(
                                child: CircularProgressIndicator(),
                                height: 20.0,
                                width: 20.0,
                              )
                            ],
                          );

                        }
                        return CircularProgressIndicator();
                      },)
                ],
              ),
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
