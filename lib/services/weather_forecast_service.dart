import 'dart:convert';
import 'dart:core';
import 'package:weatherapp/models/weather_forecast_model.dart';
import 'package:http/http.dart' as http;

class WeatherForecastService {
  static const baseUrl = 'http://api.openweathermap.org/data/2.5/forecast';
  String apiKey;

  WeatherForecastService(this.apiKey);

  Future<WeatherForecast> getWeatherForecast(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric&lang=ru')
    );

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка загрузки данных!');
    }
  }
}