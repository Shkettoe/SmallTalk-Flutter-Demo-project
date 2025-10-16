import 'package:flutter/material.dart';
import 'package:small_talk/models/weather.dart';
import 'package:small_talk/screens/about.dart';
import 'package:small_talk/screens/settings.dart';
import 'package:small_talk/services/weather_service.dart';
import 'package:small_talk/widgets/weather_widget.dart';
import 'package:small_talk/widgets/footer.dart';
import 'package:small_talk/widgets/error_display.dart';
import 'package:small_talk/exceptions/weather_exceptions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = true;
  String? _error;

  String _city = 'Ljubljana';
  void _onCityChanged(String city) {
    setState(() {
      _city = city;
      _fetchWeather();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(_city);
      if (mounted) {
        setState(() {
          _weather = weather;
          _isLoading = false;
          _error = null;
        });
      }
    } on WeatherException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'An unexpected error occurred. Please try again.';
        });
      }
    }
  }

  String _getIconUrl(String iconCode) {
    return _weatherService.getIconUrl(iconCode);
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  void _openAbout() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _openSettings();
        }
        if (details.primaryVelocity! > 0) {
          _openAbout();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Small Talk'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              _openAbout();
            },
            icon: Icon(Icons.info),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _openSettings();
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildBody()),
            CityFooter(currentCity: _city, onCityChanged: _onCityChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (_error != null) {
      return ErrorDisplay(
        message: _error!,
        onRetry: _fetchWeather,
        icon: _getErrorIcon(_error!),
      );
    }

    // Success state
    if (_weather != null) {
      return WeatherWidget(
        weather: _weather,
        iconUrl: _getIconUrl(_weather?.iconCode ?? ''),
      );
    }

    // No data state (shouldn't normally happen)
    return ErrorDisplay(
      message: 'No weather data available',
      onRetry: _fetchWeather,
      icon: Icons.cloud_off,
    );
  }

  IconData _getErrorIcon(String errorMessage) {
    if (errorMessage.contains('City not found') ||
        errorMessage.contains('valid city name')) {
      return Icons.location_off;
    } else if (errorMessage.contains('internet') ||
        errorMessage.contains('connect')) {
      return Icons.wifi_off;
    } else if (errorMessage.contains('timeout')) {
      return Icons.schedule;
    } else if (errorMessage.contains('Server')) {
      return Icons.cloud_off;
    } else {
      return Icons.error_outline;
    }
  }
}
