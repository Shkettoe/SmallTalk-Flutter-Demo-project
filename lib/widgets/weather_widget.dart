import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:small_talk/models/weather.dart';
import 'package:small_talk/data/phrases.dart';
import 'package:small_talk/providers/weather_preferences_provider.dart';

class WeatherWidget extends StatelessWidget {
  final Weather? weather;
  final String iconUrl;

  const WeatherWidget({
    super.key,
    required this.weather,
    required this.iconUrl,
  });

  String _getRandomPhrase(String weatherCondition, bool isEnabled) {
    final conditionPhrases = smallTalkPhrases[weatherCondition];
    if (conditionPhrases == null) {
      return "Nice weather we're having!";
    }

    final random = Random();

    return isEnabled
        ? conditionPhrases['Positive']![random.nextInt(
            conditionPhrases['Positive']!.length,
          )]
        : conditionPhrases['Negative']![random.nextInt(
            conditionPhrases['Negative']!.length,
          )];
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Phrase copied to clipboard!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherPreferencesProvider>(
      builder: (context, prefs, child) {
        final condition = weather?.condition ?? 'Clear';
        final isEnabled = prefs.isWeatherEnabled(condition);
        final phrase = _getRandomPhrase(condition, isEnabled);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.solid,
                        blurRadius: 15,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  child: Image.network(
                    iconUrl,
                    width: 150,
                    height: 150,
                    color: Theme.of(context).colorScheme.secondary,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.wb_sunny, size: 150);
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  '${weather?.temperature.round()}°',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "${weather?.condition} in ${weather?.city}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.secondaryContainer,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        SelectableText(
                          phrase,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontStyle: isEnabled
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () =>
                                  _copyToClipboard(context, phrase),
                              icon: const Icon(Icons.content_copy, size: 16),
                              label: const Text('Copy'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withAlpha(30),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
