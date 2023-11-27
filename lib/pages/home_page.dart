import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// api key
  final _weatherService = WeatherService("c341e34f9b7c327502cde34aa7817c5f");
  Weather? _weather;
  TextEditingController _controller = TextEditingController(text: "Город");
  String inputCityName = '';

// Получаем прогноз погоды
  _fetchWeather(inputCityName) async {
// получаем текущий город
    String city = await _weatherService.getCurrentCity();
// получить погоду для этого города
    try {
      if (inputCityName != '') {
        final weather = await _weatherService.getWeather(inputCityName);
        setState(() {
          _weather = weather;
          _controller = TextEditingController(text: _weather?.cityName ?? "Город");
        });
      } else {
        final weather = await _weatherService.getWeather(city);
        setState(() {
          _weather = weather;
          _controller = TextEditingController(text: _weather?.cityName ?? "Город");
        });
      }
    }

// если есть ошибки, то:
    catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
// получение погоды при запуске
    _fetchWeather('New York');
  }

  @override
  Widget build(BuildContext context) {
    if (_weather != null) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Center(
              child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    onTap: () {
                      _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length);
                    },
                    onSubmitted: (text) {
                      _fetchWeather(_controller.text);
                    },
                    style: const TextStyle(
                        fontFamily: '.SF UI Text',
                        fontStyle: FontStyle.italic,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(229, 76, 108, 198))),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Lottie.asset("assets/${_weather?.icon ?? "01d"}.json",
                        height: 225, width: 225),
                      Text(
                        '${_weather?.temperature.round()}°C',
                        style: const TextStyle(
                          fontFamily: '.SF UI Text',
                          fontSize: 52,
                          color: Color.fromARGB(128, 76, 108, 198),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                  Text(_weather?.description ?? "Описание",
                    style: const TextStyle(
                        fontFamily: '.SF UI Text',
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/gauge.png', height: 50, width: 50),
                    Text('${_weather?.pressure.round().toString()} мм.рт.с.' ?? "Давление"),
                    Image.asset('assets/wind.png', height: 50, width: 50),
                    Text('${_weather?.speed} м/с' ?? "Скорость ветра"),
                    Image.asset('assets/humidity.png', height: 50, width: 50),
                    Text('${_weather?.humidity}%' ?? "Влажность"),
                  ],
                ),
              ]),
            ),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

// Класс "HomePage" является изменяемым виджетом состояния и наследуется от класса
//  "StatefulWidget". В конструкторе класса указывается ключ 'key' и используется 
//  вызов конструктора суперкласса.

// Класс "_HomePageState" является состоянием виджета "HomePage" и наследуется от 
// класса "State". В этом классе определены методы и переменные для получения и 
// отображения данных о погоде.

// Метод "_fetchWeather" асинхронно получает текущий город и погодные данные с 
// использованием экземпляра класса "WeatherService". После получения данных, 
// метод обновляет состояние виджета с помощью метода "setState". Если возникают 
// ошибки, исключение обрабатывается и выводится сообщение об ошибке.

// Метод "initState" вызывается при инициализации виджета и выполняет получение 
// данных о погоде с помощью метода "_fetchWeather".

// Метод "build" строит виджет на основе полученных данных о погоде. Если данные 
// присутствуют, создается экземпляр "Scaffold" с разметкой для отображения погоды.
//  В противном случае отображается индикатор загрузки. Виджет включает в себя текст
//   с названием города и описанием погоды, а также изображения и текст с данными 
//   о давлении, скорости ветра и влажности.

// Таким образом, этот код реализует виджет "HomePage", который получает и 
// отображает данные о погоде.