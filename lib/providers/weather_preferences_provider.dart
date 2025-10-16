import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPreferencesProvider extends ChangeNotifier {
  bool _clearEnabled = true;
  bool _snowEnabled = true;
  bool _cloudsEnabled = false;
  bool _rainEnabled = false;
  String _city = 'Ljubljana';

  bool _isLoaded = false;

  bool get clearEnabled => _clearEnabled;
  bool get snowEnabled => _snowEnabled;
  bool get cloudsEnabled => _cloudsEnabled;
  bool get rainEnabled => _rainEnabled;
  String get city => _city;
  bool get isLoaded => _isLoaded;

  WeatherPreferencesProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _clearEnabled = prefs.getBool('weather_clear') ?? true;
      _snowEnabled = prefs.getBool('weather_snow') ?? true;
      _cloudsEnabled = prefs.getBool('weather_clouds') ?? false;
      _rainEnabled = prefs.getBool('weather_rain') ?? false;
      _city = prefs.getString('city') ?? 'Ljubljana';
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('weather_clear', _clearEnabled);
      await prefs.setBool('weather_snow', _snowEnabled);
      await prefs.setBool('weather_clouds', _cloudsEnabled);
      await prefs.setBool('weather_rain', _rainEnabled);
      await prefs.setString('city', _city);
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  void toggleClear(bool value) {
    _clearEnabled = value;
    _savePreferences();
    notifyListeners();
  }

  void toggleSnow(bool value) {
    _snowEnabled = value;
    _savePreferences();
    notifyListeners();
  }

  void toggleClouds(bool value) {
    _cloudsEnabled = value;
    _savePreferences();
    notifyListeners();
  }

  void toggleRain(bool value) {
    _rainEnabled = value;
    _savePreferences();
    notifyListeners();
  }

  void setCity(String city) {
    _city = city;
    _savePreferences();
    notifyListeners();
  }

  bool isWeatherEnabled(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return _clearEnabled;
      case 'snow':
        return _snowEnabled;
      case 'clouds':
        return _cloudsEnabled;
      case 'rain':
        return _rainEnabled;
      default:
        return true;
    }
  }

  List<String> getEnabledWeatherConditions() {
    final enabled = <String>[];
    if (_clearEnabled) enabled.add('Clear');
    if (_snowEnabled) enabled.add('Snow');
    if (_cloudsEnabled) enabled.add('Clouds');
    if (_rainEnabled) enabled.add('Rain');
    return enabled;
  }
}
