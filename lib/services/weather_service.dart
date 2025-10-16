import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:small_talk/models/weather.dart';
import 'package:small_talk/exceptions/weather_exceptions.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const Duration _timeout = Duration(seconds: 10);
  final String _apiKey;

  WeatherService() : _apiKey = _getApiKey();

  static String _getApiKey() {
    const apiKey = String.fromEnvironment('WEATHER_API_KEY');
    if (apiKey.isNotEmpty) {
      return apiKey;
    }

    return dotenv.env['WEATHER_API_KEY'] ?? '';
  }

  /// Validates city name format
  bool _isValidCityName(String city) {
    // Allow letters, spaces, hyphens, and apostrophes
    final validPattern = RegExp(r"^[a-zA-Z\s\-']+$");
    return city.trim().isNotEmpty && validPattern.hasMatch(city.trim());
  }

  Future<Weather> getCurrentWeather(String city) async {
    // Validate city name before making request
    if (!_isValidCityName(city)) {
      throw InvalidCityNameException();
    }

    // Check if API key is available
    if (_apiKey.isEmpty) {
      throw ApiKeyException();
    }

    final url = Uri.parse(
      '$_baseUrl/weather?q=${city.trim()}&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw CityNotFoundException(city);
      } else if (response.statusCode == 401) {
        throw ApiKeyException();
      } else if (response.statusCode >= 500) {
        throw ServerException(response.statusCode);
      } else {
        throw WeatherException(
          'Unexpected error: ${response.statusCode}',
          userMessage: 'Unable to fetch weather data. Please try again.',
        );
      }
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw WeatherException(
        'Request timed out',
        userMessage: 'Request timed out. Please try again.',
      );
    } on http.ClientException {
      throw NetworkException();
    } on FormatException {
      throw WeatherException(
        'Invalid response format',
        userMessage: 'Received invalid data. Please try again.',
      );
    } catch (e) {
      // If it's already a WeatherException, rethrow it
      if (e is WeatherException) {
        rethrow;
      }
      // Otherwise wrap it in a generic WeatherException
      throw WeatherException(
        'Unexpected error: $e',
        userMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
