import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/weather_model.dart';
import 'app_provider.dart';

class WeatherProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  LoadingState weatherState = LoadingState.initial;
  WeatherModel? weatherData;
  String errorMessage = '';

  void searchWeather(String city) async {
    if (city.trim().isEmpty) return;
    weatherState = LoadingState.loading;
    notifyListeners();

    try {
      weatherData = await _apiService.getWeatherByCity(city);
      weatherState = LoadingState.success;
    } catch (e) {
      weatherState = LoadingState.error;
      errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }
}
