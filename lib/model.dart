import 'wid.dart';

class Weather {
    String temperature = '';
    String weather = '';
    String wind = '';
    String date = '';
    String week = '';
    String uvIndex = '';
    String dateY = '';
    String city = '';
    Map weatherId;

    Weather();
    Weather.fromJson(Map data) {
      this.temperature = data["temperature"];
      this.weather = data["weather"];
      this.wind = data["wind"];
      this.week = data["week"];
      this.uvIndex = data["uv_index"];
      this.dateY = data["date_y"];
      this.city = data["city"];
      this.weatherId = data["weather_id"];
    }

    String get weatherImg {
      if (weatherId == null) {
        return 'images/cloud.png';
      }
      else {
        for (var wid in WID.data) {
          if (wid['wid'] == weatherId['fa']) {
            if (wid['img1'] == '') {
              return 'images/cloud.png';
            }
            return 'images/' + wid['img1'] + '.png';
          }
        }
      }
      return 'images/cloud.png';
    }

    String get bigWeatherImg {
      if (weatherId == null) {
        return 'images/cloud.png';
      }
      else {
        for (var wid in WID.data) {
          if (wid['wid'] == weatherId['fa']) {
            if (wid['img2'] == '') {
              return 'images/cloud.png';
            }
            return 'images/' + wid['img2'] + '.png';
          }
        }
      }
      return 'images/cloud.png';
    }
}

class WeatherSK {
    String temp = '';
    String windDirection = '';
    String windStrength = '';
    String humidity = '';
    String time = '';
    WeatherSK();
    WeatherSK.fromJson(Map data) {
      this.temp = data["temp"];
      this.windDirection = data["wind_direction"];
      this.windStrength = data["wind_strength"];
      this.humidity = data["humidity"];
      this.time = data["time"];
    }
}
