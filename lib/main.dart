import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'model.dart';
import 'package:dio/dio.dart';
import 'dart:io';

void main() => runApp(WeatherApp());

Future<String> loadAsset() async {
  return await rootBundle.loadString('data/data.json');
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => new _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Weather today;
  WeatherSK sk;
  List<Widget> futureWeather;
  String cityName = 'abc';

  _WeatherAppState() {
    today = Weather();
    sk = WeatherSK();
    futureWeather = <Widget>[];
  }

  void loadData() {
    var data = loadAsset();
    data.then(parseData);
  }

  void parseData(String jsonStr) {
    var data = json.decode(jsonStr);
    // debugPrint('-->' + data['message']);
    var result = data['result'];
    var w = Weather.fromJson(result['today']);
    var s = WeatherSK.fromJson(result['sk']);
    // debugPrint('-->' + this.today.city);
    this.cityName = today.city;

    Map futureData = result['future'];
    List<Widget>week = <Widget>[];
    for (var key in futureData.keys) {
      Weather w = Weather.fromJson(futureData[key]);
      week.add(buildFutureItem(w.week, w.weatherImg, w.temperature));
    }

    setState(() {
      this.today = w;
      this.sk = s;
      this.futureWeather = week;
    });
  }

  void loadWeather() async {
    var dio = Dio(Options(
      baseUrl: 'http://weatherapi.market.alicloudapi.com',
      headers: {'Authorization' : 'APPCODE 691a8c4d415449ffb69b1a7ac2a4000d'},
      responseType: ResponseType.JSON,
    ));

    FormData formData = new FormData.from({
    "cityName": "北京",
    });

    try {
      Response<Map> responseMap = await dio.post('/weather/TodayTemperatureByCity', data: formData);
      print(responseMap.data);
      parseWeather(responseMap.data);
    } on DioError catch(e) {
      print(e);
      print(e.response.statusCode);
      print(e.response.headers);
      print(e.response.data);
    }
  }

  void parseWeather(Map data) {
    var result = data['result'];
    var w = Weather.fromJson(result['today']);
    var s = WeatherSK.fromJson(result['sk']);
    debugPrint('-->' + this.today.city);
    this.cityName = today.city;

    Map futureData = result['future'];
    List<Widget>week = <Widget>[];
    for (var key in futureData.keys) {
      Weather w = Weather.fromJson(futureData[key]);
      week.add(buildFutureItem(w.week, w.weatherImg, w.temperature));
    }

    setState(() {
      this.today = w;
      this.sk = s;
      this.futureWeather = week;
    });
  }


  @override
  void initState() {
    super.initState();
    // loadData();
    loadWeather();
  }

  Widget buildFutureItem(String weekday, String weatherImg, String temp) {
      return Container(
        height: 160.0,
        width: 115.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      weekday,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Image.asset(
                        weatherImg,
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.fill,
                      ),
                    Text(
                      temp,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                )); 
    }

  @override
  Widget build(BuildContext context) {
    Widget headerSection = Container(
      margin: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Image.asset(
              today.bigWeatherImg,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
          Expanded(
            child: Column(children: <Widget>[
              Text(today.city,
              style: TextStyle(
                
              ),),
              Text(today.weather)
            ])
          ),
          Container(
              width: 80.0,
              height: 80.0,
            ),
        ],
      ),
    );

    Widget tempSection = Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset(0.5, 0.5),
              child: Text(
                sk.temp,
                style: TextStyle(
                  fontSize: 240.0,
                  fontFamily: 'AdobeClean',
                  ),
                ),
              ),
            Align(
              alignment: FractionalOffset(0.9, 0.0),
              child: Text(
                '℃',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Color(0xFF707070),
                ),
              ),
            )
          ],
        ),
    );
    Widget detailSection = Container(
      child: Center(
        child: Text(
          today.dateY + ' ' + sk.time + '发布',
          style: TextStyle(
            fontSize: 16.0,
          ),),
      ),
    ); 

    Widget middle = Container(
      child: Column(
        children: <Widget>[
          tempSection,
          detailSection,
        ],
      ),
    );
    Row buildWeatherItem(String icon, String text) {
      return Row(
        children: <Widget>[
          Image.asset(
              icon,
              width: 30.0,
              height: 30.0,
              fit: BoxFit.cover,
            ),
          Text(
            text
          )
        ],
      );
    }

    Widget buttonSection = Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildWeatherItem('images/windspeed.png', sk.windStrength),
          buildWeatherItem('images/bad.png', today.uvIndex),
          buildWeatherItem('images/shidu.png', sk.humidity),
        ],
      ),
    );

    Widget future = Container(
      height: 160.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: futureWeather,
      ),
    );

    Widget bottom = Column(
      children: <Widget>[
        buttonSection,
        Divider(
          height: 1.0,
          color: Color(0xFF333333),
          ),
        future,
      ],
    );

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Top Lakes'),
        // ),
        body: Container(
          margin: const EdgeInsets.only(top: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              headerSection,
              middle,
              bottom,
            ],
          )
        ),
      ),
    );
  }
}
