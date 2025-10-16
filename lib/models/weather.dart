class Weather {
  final String city;
  final double temperature;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      condition: json['weather'][0]['main'] ?? 'Unknown',
      description: json['weather'][0]['description'] ?? 'Unknown',
      humidity: (json['main']['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      iconCode: json['weather'][0]['icon'] ?? 'Unknown',
    );
  }
}
