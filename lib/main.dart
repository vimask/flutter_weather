import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather/models/condition.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  initState() {
    super.initState();
    _locateUser = locateUser();
  }

  // MARK: --------------------------------------------------------------------------------------
  // --------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------
  final String mainURL = "http://api.openweathermap.org/data/2.5";
  static const String APIKEY = "276f691a37ba15a1905de29a432ca3e1";

  Position currenLocation;
  Future<Position> _locateUser;
  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((location) {
      if (location != null) {
        print("Location: ${location.latitude},${location.longitude}");
      }
      return location;
    });
  }

  Future<CurrentWeather> fetchCurrentConditions(Position location) async {
    final response = await http.get(
        '$mainURL/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&APIKEY=$APIKEY');
    if (response.statusCode == 200) {
      CurrentWeather currentWeather =
          CurrentWeather.fromJson(json.decode(response.body));
      return currentWeather;
    } else {
      print("Failed to load post");
      throw Exception('Failed to load post');
    }
  }

  Future<WCondition> fetchDailyForecast(Position location) async {
    final response = await http.get(
        '$mainURL/forecast/daily?lat=${location.latitude}&lon=${location.longitude}&units=metric&cnt=7&APIKEY=$APIKEY');
    if (response.statusCode == 200) {
      print("json: ${json.decode(response.body)}");
      return WCondition.fromJson(json.decode(response.body));
    } else {
      print("Failed to load post");
      throw Exception('Failed to load post');
    }
  }

  Future<WCondition> fetchHourlyForecast(Position location) async {
    final response = await http.get(
        '$mainURL/forecast?lat=${location.latitude}&lon=${location.longitude}&units=metric&cnt=7&APIKEY=$APIKEY');
    if (response.statusCode == 200) {
      print("json: ${json.decode(response.body)}");
      return WCondition.fromJson(json.decode(response.body));
    } else {
      print("Failed to load post");
      throw Exception('Failed to load post');
    }
  }

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
              color: Colors.black, child: Image.asset('assets/bg.png',fit: BoxFit.fitWidth)),
        ),
        PageView(
          children: <Widget>[
            FutureBuilder<CurrentWeather>(
              future: Future.wait([_locateUser]).then(
                (response) => fetchCurrentConditions(response[0]),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return firstPage(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return Center(child: CircularProgressIndicator());
              },
            ),

            FutureBuilder<WCondition>(
              future: Future.wait([_locateUser]).then(
                (response) => fetchHourlyForecast(response[0]),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return secondPage(context, snapshot.data.list);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return Center(child: CircularProgressIndicator());
              },
            ),

            FutureBuilder<WCondition>(
              future: Future.wait([_locateUser]).then(
                (response) => fetchDailyForecast(response[0]),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return thirdPage(context, snapshot.data.list);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return Center(child: CircularProgressIndicator());
              },
            ),
            // Add children here
          ],
          scrollDirection: Axis.vertical,
        ),
      ],
    ));
  }

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
  BackdropFilter thirdPage(BuildContext context, List<ListElement> weathers) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    indent: (index == 0) ? 10 : 70,
                    color: Colors.white70,
                  ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weathers.length + 1,
              itemBuilder: (BuildContext ctxt, int index) {
                //title
                if (index == 0) {
                  return Container(
                      height: 40,
                      child: Text("  Daily Forecase",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontFamily: "HelveticaNeue")));
                }

                Weather weather = weathers[index - 1].weather.first;
                return Container(
                  height: (MediaQuery.of(context).size.height - 40) /
                      (weathers.length + 2),
                  child: new Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                          height: 45.0,
                          width: 45.0,
                          child: Image.asset(weather.assetIcon())),
                    ),
                    Text(
                      "${weathers[index - 1].date()}",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: "HelveticaNeue"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: Text(
                          "${weathers[index - 1].temp.day}°C",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontFamily: "HelveticaNeue"),
                        ),
                      ),
                    ),
                  ]),
                );
              }),
        ),
      ),
    );
  }

  BackdropFilter secondPage(BuildContext context, List<ListElement> weathers) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    indent: (index == 0) ? 10 : 70,
                    color: Colors.white70,
                  ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weathers.length + 1,
              itemBuilder: (BuildContext ctxt, int index) {
                //title
                if (index == 0) {
                  return Container(
                      height: 40,
                      child: Text("  Hourly Forecase",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontFamily: "HelveticaNeue")));
                }

                Weather weather = weathers[index - 1].weather.first;
                return Container(
                  height: (MediaQuery.of(context).size.height - 40) /
                      (weathers.length + 2),
                  child: new Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                          height: 45.0,
                          width: 45.0,
                          child: Image.asset(weather.assetIcon())),
                    ),
                    Text(
                      "${weathers[index - 1].timeHour()}",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: "HelveticaNeue"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          "${weathers[index - 1].main.temp}°C",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontFamily: "HelveticaNeue"),
                        ),
                      ),
                    ),
                  ]),
                );
              }),
        ),
      ),
    );
  }

  //MARK: first page
  FractionallySizedBox firstPage(CurrentWeather weather) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text("${weather.name}",
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontFamily: "HelveticaNeue")),
            ),
            Expanded(
              child: Container(),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                    height: 30.0,
                    width: 30.0,
                    child: Image.asset(weather.weather.first.assetIcon())),
              ),
              Text(
                "${weather.weather.first.main}",
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontFamily: "HelveticaNeue"),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${weather.main.temp}°C",
                      style: TextStyle(
                          fontSize: 120.0,
                          color: Colors.white,
                          fontFamily: "HelveticaNeue"),
                    ),
                  ]),
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                    child: Text(
                        "${weather.main.tempMax}°C / ${weather.main.tempMin}°C",
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontFamily: "HelveticaNeue")),
                  )
                ]),
          ],
        ),
      ),
    );
  }
}

class $ {}
