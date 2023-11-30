import 'package:flutter/material.dart';
import 'package:weatherapp/dependency_injection.dart';
import 'pages/home_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WeatherApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(228, 106, 145, 253)),
          useMaterial3: true,
        ),
        
        home: const HomePage());
  }
}


