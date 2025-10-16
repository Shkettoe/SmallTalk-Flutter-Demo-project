import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:small_talk/providers/weather_preferences_provider.dart';

class CityFooter extends StatefulWidget {
  final String currentCity;
  final Function(String) onCityChanged;

  const CityFooter({
    super.key,
    required this.currentCity,
    required this.onCityChanged,
  });

  @override
  State<CityFooter> createState() => _CityFooterState();
}

class _CityFooterState extends State<CityFooter> {
  bool _searchMode = false;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.currentCity);
  }

  @override
  void didUpdateWidget(CityFooter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentCity != widget.currentCity && !_searchMode) {
      _cityController.text = widget.currentCity;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _toggleSearchMode(WeatherPreferencesProvider prefs) {
    if (_searchMode) {
      final newCity = _cityController.text.trim();
      if (newCity.isNotEmpty && newCity != widget.currentCity) {
        widget.onCityChanged(newCity);
        prefs.setCity(newCity);
      } else {
        _cityController.text = widget.currentCity;
      }
    }
    setState(() {
      _searchMode = !_searchMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherPreferencesProvider>(
      builder: (context, prefs, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          enabled: _searchMode,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: _searchMode ? null : InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: _searchMode
                      ? const Icon(Icons.check)
                      : const Icon(Icons.search),
                  onPressed: () => _toggleSearchMode(prefs),
                  tooltip: 'Change city',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
