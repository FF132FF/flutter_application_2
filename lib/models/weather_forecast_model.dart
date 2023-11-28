class WeatherForecast {
  final double temperature;
  final double feelsLike;
  final double pressure;
  final String humidity;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final double windSpeed;

  WeatherForecast({
    required this.temperature,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.windSpeed
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      temperature: json['list'][0]['temp'], 
      feelsLike: json['list'][0]['feels_like'], 
      pressure: json['list'][0]['pressure'], 
      humidity: json['list'][0]['humidity'], 
      weatherMain: json['list'][0]['weather'][0]['main'], 
      weatherDescription: json['list'][0]['weather'][0]['description'], 
      weatherIcon: json['list'][0]['weather'][0]['icon'],
      windSpeed: json['list'][0]['wind'][0]['speed']
    );
  }
}