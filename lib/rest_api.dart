import 'weather_model.dart';
import 'package:http/http.dart' as http;

Future<List<DailyForcast>> fetchWeather() async {
  final response = await http
      .get(Uri.parse('https://api.openweathermap.org/data/2.5/onecall?lat=46.8&lon=-92.1&exclude=hourly,current,minutely,alerts&units=imperial&appid=b15632ec4a9f1a874aeb15b3e22c4503'));

  if (response.statusCode == 200) {

    print('fetchWeather - '+response.body);
    Weather weather = weatherFromJson(response.body);
    return weather.daily;
  } else {

    throw Exception('Failed to load album');
  }
}