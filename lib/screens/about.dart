import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => {
        if (details.primaryVelocity! < 0) {Navigator.pop(context)},
      },
      child: Scaffold(
        appBar: AppBar(title: Text('About'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'Weather: humanity\'s favourite conversation filler since the dawn of awkward social interactions.\n\nSmallTalk application provides you with a real-time weather data AND the socially acceptable phrases to discuss it.\n\nBecause sometimes "nice weather" is easier than "how are you really?"\n\nBuild with Flutter by Denis Tošić',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
