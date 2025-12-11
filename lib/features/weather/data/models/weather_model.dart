/// Represents weather data for a specific location
class Weather {
  final String location;
  final double temperature;
  final double feelsLike;
  final String condition;
  final double humidity;
  final double windSpeed;
  final double uvIndex;
  final double airPressure; // in hPa
  final double visibility; // in km
  final DateTime lastUpdated;

  Weather({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
    required this.airPressure,
    required this.visibility,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'location': location,
    'temperature': temperature,
    'feelsLike': feelsLike,
    'condition': condition,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'uvIndex': uvIndex,
    'airPressure': airPressure,
    'visibility': visibility,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    location: json['location'] as String,
    temperature: (json['temperature'] as num).toDouble(),
    feelsLike: (json['feelsLike'] as num).toDouble(),
    condition: json['condition'] as String,
    humidity: (json['humidity'] as num).toDouble(),
    windSpeed: (json['windSpeed'] as num).toDouble(),
    uvIndex: (json['uvIndex'] as num).toDouble(),
    airPressure: (json['airPressure'] as num).toDouble(),
    visibility: (json['visibility'] as num).toDouble(),
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
  final double? precipitation;
  final double? uvIndex;
  final double? visibility;

  ForecastDay({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    this.precipitation,
    this.uvIndex,
    this.visibility,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'minTemp': minTemp,
    'maxTemp': maxTemp,
    'condition': condition,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'precipitation': precipitation,
    'uvIndex': uvIndex,
    'visibility': visibility,
  };

  factory ForecastDay.fromJson(Map<String, dynamic> json) => ForecastDay(
    date: DateTime.parse(json['date'] as String),
    minTemp: (json['minTemp'] as num).toDouble(),
    maxTemp: (json['maxTemp'] as num).toDouble(),
    condition: json['condition'] as String,
    humidity: (json['humidity'] as num).toDouble(),
    windSpeed: (json['windSpeed'] as num).toDouble(),
    precipitation: json['precipitation'] != null ? (json['precipitation'] as num).toDouble() : null,
    uvIndex: json['uvIndex'] != null ? (json['uvIndex'] as num).toDouble() : null,
    visibility: json['visibility'] != null ? (json['visibility'] as num).toDouble() : null,
  );
}

/// Weather trend analysis with historical and forecast data
class WeatherTrend {
  final List<ForecastDay> historical; // Last 10 days
  final Weather current;
  final List<ForecastDay> forecast; // Next 10 days
  final WeatherInsight insight;

  WeatherTrend({
    required this.historical,
    required this.current,
    required this.forecast,
    required this.insight,
  });
}

/// Dynamic weather insights for farmers
class WeatherInsight {
  final String titleKey; // Translation key
  final String descriptionKey; // Translation key
  final String recommendationKey; // Translation key
  final InsightType type;
  final InsightPriority priority;

  WeatherInsight({
    required this.titleKey,
    required this.descriptionKey,
    required this.recommendationKey,
    required this.type,
    required this.priority,
  });
}

enum InsightType {
  rain,
  temperature,
  irrigation,
  pestAlert,
  harvest,
  sowing,
  fertilizer,
  uvWarning,
  windAlert,
  general,
}

enum InsightPriority {
  critical,
  high,
  medium,
  low,
}
