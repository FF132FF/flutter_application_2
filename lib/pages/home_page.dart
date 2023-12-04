import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:weatherapp/models/weather_forecast_model.dart';
import 'package:weatherapp/services/weather_forecast_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// api key 
  late String _backgroundImage = '';
  late List<String> _days = [];
  
  // final List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  final List<String> temperatures = ['25°C', '28°C', '30°C', '26°C', '24°C'];
  final _weatherService = WeatherService("7fe9d074a8162e72b8a8c6cc42ccb162");
  final _predictService = PredictService("7fe9d074a8162e72b8a8c6cc42ccb162");
  Weather? _weather;
  Predict? _predict;
  TextEditingController _controller = TextEditingController(text: "Город");
  String inputCityName = '';

  void _setDaysList() {
    var dayNow = DateFormat('EEEE').format(DateTime.now());
    if (dayNow == 'Sunday') {
      setState(() {
        _days = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница'];
      });
    } else if (dayNow == 'Monday') {
      setState(() {
        _days = ['Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'];
      });
    } else if (dayNow == 'Tuesday') {
      setState(() {
        _days = ['Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
      });
    } else if (dayNow == 'Wednesday') {
      setState(() {
        _days = ['Четверг', 'Пятница', 'Суббота', 'Воскресенье', 'Понедельник'];
      });
    } else if (dayNow == 'Thursday') {
      setState(() {
        _days = ['Пятница', 'Суббота', 'Воскресенье', 'Понедельник', 'Вторник'];
      });
    } else if (dayNow == 'Friday') {
      setState(() {
        _days = ['Суббота', 'Воскресенье', 'Понедельник', 'Вторник', 'Среда'];
      });
    } else if (dayNow == 'Saturday') {
      setState(() {
        _days = ['Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг'];
      });
    }
  }

  void _setBackgroundImage() {
    var hourNow = int.parse(DateFormat('kk').format(DateTime.now()));
    if (hourNow >= 23 || hourNow < 4) {
      setState(() {
        _backgroundImage = "night.jpg";
      });
    } else if (hourNow >= 4 && hourNow < 12) {
      setState(() {
        _backgroundImage = "night.jpg";
      });
    } else if (hourNow >= 12 && hourNow < 17) {
      setState(() {
        _backgroundImage = "night.jpg";
      });
    } else if (hourNow >= 17 && hourNow < 23) {
      setState(() {
        _backgroundImage = "night.jpg";
      });
    }
  }
// Получаем прогноз погоды
  _fetchWeather(inputCityName) async {
// получаем текущий город
    String city = await _weatherService.getCurrentCity();
// получить погоду для этого города
    try {
      if (inputCityName != '') {
        String resultCity = inputCityName.trim();
        final predict = await _predictService.getPredict(resultCity);
        final weather = await _weatherService.getWeather(resultCity);
        setState(() {
          _weather = weather;
          _predict = predict;
          _controller = TextEditingController(text: _weather?.cityName ?? "Город");
        });
      } else {
        final predict = await _predictService.getPredict(city);
        final weather = await _weatherService.getWeather(city);
        setState(() {
          _weather = weather;
          _predict = predict;
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
    _fetchWeather(inputCityName);
    _setBackgroundImage();
    _setDaysList();
  }

  @override
  Widget build(BuildContext context) {
    if (_weather != null) {
      return Scaffold(
        body: SingleChildScrollView(
          // child: Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage(_backgroundImage),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Center(
                child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.bottomCenter,
                      child: Flexible(
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          textAlign: TextAlign.center,
                          controller: _controller,
                          onTap: () {
                            _controller.clear();
                            _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length);
                          },
                          onSubmitted: (text) {
                            _fetchWeather(_controller.text);
                          },
                          cursorColor: const Color.fromARGB(255, 114, 185, 213), cursorWidth: 0.5,
                          style: const TextStyle(
                            fontFamily: '.SF UI Text',
                            fontStyle: FontStyle.italic,
                            fontSize: 52,
                            fontWeight: FontWeight.w400,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationColor: Color.fromARGB(255, 114, 185, 213),
                            color: Color.fromARGB(255, 114, 185, 213),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 114, 185, 213),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Lottie.asset("assets/${_weather?.icon ?? "01d"}.json",
                          height: 225, width: 225),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(width: 0, height: 100),
                            Text(
                              '${_weather?.temperature.round()}°C',
                              style: const TextStyle(
                                fontFamily: '.SF UI Text',
                                fontSize: 52,
                                color: Color.fromARGB(200, 114, 185, 213),
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic),
                            )
                          ]
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Flexible(
                        child: Text(_weather?.description ?? "Описание",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: '.SF UI Text',
                              fontSize: 26,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 114, 185, 213))),
                      ),
                    ],),
                  Container(
                    margin: const EdgeInsets.only(right: 30, left: 10, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/gauge.png', height: 50, width: 50),
                            Container(height: 10),
                            Text('${_weather?.pressure.round().toString()} мм.рт.с.' ?? "Давление",
                            style: const TextStyle(
                            fontFamily: '.SF UI Text',
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(200, 188, 76, 198))),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset('assets/wind.png', height: 50, width: 50),
                            Container(height: 10),
                            Text('${_weather?.speed} м/с' ?? "Скорость ветра",
                            style: const TextStyle(
                            fontFamily: '.SF UI Text',
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(200, 76, 198, 157))),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset('assets/humidity.png', height: 50, width: 50),
                            Container(height: 10),
                            Text('${_weather?.humidity}%' ?? "Влажность",
                            style: const TextStyle(
                            fontFamily: '.SF UI Text',
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(200, 76, 176, 198))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 30, left: 10, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Lottie.asset("assets/${_predict?.list[0].weather[0].icon ?? "01d"}.json", height: 52, width: 52),
                          ],
                        ),
                        Column(
                          children: [
                            Text('${_predict?.list[0].main?.temp.toInt()}' ?? "Влажность",
                            style: const TextStyle(
                            fontFamily: '.SF UI Text',
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 114, 185, 213)
                            )),
                            
                          ],
                        ),
                        Column(
                          children: [
                            Text('${_predict?.list[0].weather[0].description}' ?? "Скорость ветра",
                            style: const TextStyle(
                            fontFamily: '.SF UI Text',
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 114, 185, 213)
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 720,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _days.length,
                      itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 1000,
                        width: 320,
                        margin: EdgeInsets.all(20),
                        child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                              _days[index],
                              style: const TextStyle(fontSize: 26, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
                            )],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [ 
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                              Column(
                                children: [
                                  Text(
                                    temperatures[index],
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 114, 185, 213), fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                                  )],
                              ),
                            ],
                          ),
                        ],
                      ),
                      ),
                    );
                    },
                  ),
                  ),
                ]),
              ),
            ),
          ),
        // ),
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