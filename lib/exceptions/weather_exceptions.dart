/// Custom exceptions for weather-related errors
library;

class WeatherException implements Exception {
  final String message;
  final String? userMessage;

  WeatherException(this.message, {this.userMessage});

  @override
  String toString() => userMessage ?? message;
}

class CityNotFoundException extends WeatherException {
  CityNotFoundException(String cityName)
    : super(
        'City "$cityName" not found',
        userMessage: 'City not found. Please check the spelling and try again.',
      );
}

class NetworkException extends WeatherException {
  NetworkException()
    : super(
        'Network error occurred',
        userMessage:
            'Unable to connect. Please check your internet connection.',
      );
}

class TimeoutException extends WeatherException {
  TimeoutException()
    : super(
        'Request timed out',
        userMessage: 'Request timed out. Please try again.',
      );
}

class ApiKeyException extends WeatherException {
  ApiKeyException()
    : super(
        'Invalid API key',
        userMessage: 'Configuration error. Please contact support.',
      );
}

class ServerException extends WeatherException {
  final int statusCode;

  ServerException(this.statusCode)
    : super(
        'Server error: $statusCode',
        userMessage: 'Server error occurred. Please try again later.',
      );
}

class InvalidCityNameException extends WeatherException {
  InvalidCityNameException()
    : super(
        'Invalid city name',
        userMessage: 'Please enter a valid city name (letters only).',
      );
}
