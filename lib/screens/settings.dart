import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:small_talk/providers/weather_preferences_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => {
        if (details.primaryVelocity! > 0) {Navigator.pop(context)},
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Preferences'), centerTitle: true),
        body: Consumer<WeatherPreferencesProvider>(
          builder: (context, prefs, child) {
            if (!prefs.isLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Weather Preferences',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Check the weather conditions you like and leave the ones you don\'t like unchecked',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildWeatherToggle(
                  context: context,
                  title: 'Clear',
                  subtitle: 'Sunny and clear skies',
                  icon: Icons.wb_sunny,
                  iconColor: Colors.orange,
                  value: prefs.clearEnabled,
                  onChanged: prefs.toggleClear,
                ),
                _buildWeatherToggle(
                  context: context,
                  title: 'Rain',
                  subtitle: 'Rainy weather',
                  icon: Icons.water_drop,
                  iconColor: Colors.blue,
                  value: prefs.rainEnabled,
                  onChanged: prefs.toggleRain,
                ),
                _buildWeatherToggle(
                  context: context,
                  title: 'Clouds',
                  subtitle: 'Cloudy skies',
                  icon: Icons.cloud,
                  iconColor: Colors.grey,
                  value: prefs.cloudsEnabled,
                  onChanged: prefs.toggleClouds,
                ),
                _buildWeatherToggle(
                  context: context,
                  title: 'Snow',
                  subtitle: 'Snowy conditions',
                  icon: Icons.ac_unit,
                  iconColor: Colors.lightBlue,
                  value: prefs.snowEnabled,
                  onChanged: prefs.toggleSnow,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeatherToggle({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: iconColor, size: 32),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Theme.of(context).colorScheme.primary,
    );
  }
}
