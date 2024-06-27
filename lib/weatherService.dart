import 'dart:convert';
import 'package:http/http.dart' as http;


class WeatherData {
  late final num temp;
}

 late Future<WeatherData> weatherData;

class Weather {

  static Future<WeatherData> fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=55.8099875&longitude=37.8235783&current=temperature_2m,weather_code&timezone=GMT&forecast_days=1'));

    var jsonData = jsonDecode(response.body);

    WeatherData wd = WeatherData();
    var a = jsonData["current"]["temperature_2m"];
    wd.temp = a.round();

    return Future.value(wd);
  }
}
