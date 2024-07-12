import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  static num? temp;
}

late Future<WeatherData> weatherData;

class Weather {
  static Future<void> fetchWeather(lat, lon) async {
    if (lat == null && lon == null) {
      return;
    }

    http.Response response;
    try {
      var a = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&timezone=GMT&forecast_days=1'));
      response = a;
    } on Exception {
      WeatherData.temp = null;
      return;
    }

    var jsonData = jsonDecode(response.body);

    var a = jsonData["current"]["temperature_2m"];
    WeatherData.temp = a.round();

    return;
  }
}
