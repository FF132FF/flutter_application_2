// https://dart-quicktype.netlify.app/
import 'dart:convert';
import 'dart:core';
import '../models/weather_forecast_model.dart';
import 'package:http/http.dart' as http;

class PredictService {
  static const baseUrl = 'http://api.openweathermap.org/data/2.5/forecast';
  String apiKey;

  PredictService(this.apiKey);

  Future<Predict> getPredict(String cityName) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?q=$cityName&appid=$apiKey&units=metric&lang=ru'));

    if (response.statusCode == 200) {
      return Predict.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка загрузки данных!');
    }
  }
}


// void main(List<String> args) async {
//   const url = 'https://api.openweathermap.org/data/2.5/forecast';
//   String apiKey = "c341e34f9b7c327502cde34aa7817c5f";

//   Future<Predict> getPredict(String cityName) async {
//     final response = await http.get(Uri.parse(
//         '$url?q=$cityName&appid=$apiKey&units=metric&lang=ru'));

//     if (response.statusCode == 200) {
//       return Predict.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Ошибка загрузки данных!');
//     }
//   }

  // final predict = await getPredict(InputCityName);
  // print(predict.list[0].weather[0].description);
  // print(predict.list[0].main?.temp);
  // print(predict.list[0].main?.tempKf);
  // print(predict.list[0].wind?.speed);
  // return predict;
// }






// import 'dart:convert';
// import 'dart:core';
// import 'package:weatherapp/models/weather_forecast_model.dart';
// import 'package:http/http.dart' as http;

// class WeatherForecastService {
//   static const baseUrl = 'http://api.openweathermap.org/data/2.5/forecast';
//   String apiKey;

//   WeatherForecastService(this.apiKey);

//   Future<WeatherForecast> getWeatherForecast(String cityName) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric&lang=ru')
//     );

//     if (response.statusCode == 200) {
//       return WeatherForecast.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Ошибка загрузки данных!');
//     }
//   }
// }