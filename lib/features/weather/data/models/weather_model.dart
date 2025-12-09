/// Represents weather data for a specific location
class Weather {
  final String location;
  final double temperature;
  final String condition;
  final double humidity;
  final double windSpeed;
  final DateTime lastUpdated;

  Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'location': location,
    'temperature': temperature,
    'condition': condition,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    location: json['location'] as String,
    temperature: (json['temperature'] as num).toDouble(),
    condition: json['condition'] as String,
    humidity: (json['humidity'] as num).toDouble(),
    windSpeed: (json['windSpeed'] as num).toDouble(),
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  );
}

/// Represents weather forecast for a single day
class ForecastDay {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String condition;
  final double humidity;
  final double windSpeed;

  ForecastDay({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'minTemp': minTemp,
    'maxTemp': maxTemp,
    'condition': condition,
    'humidity': humidity,
    'windSpeed': windSpeed,
  };

  factory ForecastDay.fromJson(Map<String, dynamic> json) => ForecastDay(
    date: DateTime.parse(json['date'] as String),
    minTemp: (json['minTemp'] as num).toDouble(),
    maxTemp: (json['maxTemp'] as num).toDouble(),
    condition: json['condition'] as String,
    humidity: (json['humidity'] as num).toDouble(),
    windSpeed: (json['windSpeed'] as num).toDouble(),
  );
}
