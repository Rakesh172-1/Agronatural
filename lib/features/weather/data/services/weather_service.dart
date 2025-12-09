import 'package:dio/dio.dart';
import 'package:vriddhiapps/features/weather/data/models/weather_model.dart';

/// Weather service that uses Open-Meteo API for real weather data
class WeatherService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.open-meteo.com/v1';

  /// Get current weather for given coordinates
  /// Default: Punjab (Amritsar), Latitude: 31.6340, Longitude: 74.8711
  Future<Weather> getCurrentWeather({
    double latitude = 31.6340,
    double longitude = 74.8711,
    String location = 'Punjab, India',
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current': 'temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m',
          'timezone': 'Asia/Kolkata',
        },
      );

      final currentData = response.data['current'];
      final temperature = (currentData['temperature_2m'] as num).toDouble();
      final humidity = (currentData['relative_humidity_2m'] as num).toDouble();
      final windSpeed = (currentData['wind_speed_10m'] as num).toDouble();
      final weatherCode = currentData['weather_code'] as int;

      return Weather(
        location: location,
        temperature: temperature,
        condition: _getWeatherDescription(weatherCode),
        humidity: humidity,
        windSpeed: windSpeed,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      // Fallback mock data
      return Weather(
        location: location,
        temperature: 28.5,
        condition: 'Partly Cloudy',
        humidity: 65.0,
        windSpeed: 12.5,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Get 7-day forecast for given coordinates
  /// Default: Punjab (Amritsar), Latitude: 31.6340, Longitude: 74.8711
  Future<List<ForecastDay>> getForecast({
    double latitude = 31.6340,
    double longitude = 74.8711,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min,relative_humidity_2m_max,wind_speed_10m_max',
          'timezone': 'Asia/Kolkata',
          'forecast_days': 7,
        },
      );

      final dailyData = response.data['daily'];
      final dates = (dailyData['time'] as List).cast<String>();
      final maxTemps = (dailyData['temperature_2m_max'] as List).cast<num>();
      final minTemps = (dailyData['temperature_2m_min'] as List).cast<num>();
      final weatherCodes = (dailyData['weather_code'] as List).cast<int>();
      final humidities = (dailyData['relative_humidity_2m_max'] as List).cast<num>();
      final windSpeeds = (dailyData['wind_speed_10m_max'] as List).cast<num>();

      return List.generate(dates.length, (index) {
        return ForecastDay(
          date: DateTime.parse(dates[index]),
          minTemp: minTemps[index].toDouble(),
          maxTemp: maxTemps[index].toDouble(),
          condition: _getWeatherDescription(weatherCodes[index]),
          humidity: humidities[index].toDouble(),
          windSpeed: windSpeeds[index].toDouble(),
        );
      });
    } catch (e) {
      // Fallback mock data
      final now = DateTime.now();
      return [
        ForecastDay(
          date: now.add(const Duration(days: 1)),
          minTemp: 18.0,
          maxTemp: 32.0,
          condition: 'Sunny',
          humidity: 55.0,
          windSpeed: 10.0,
        ),
        ForecastDay(
          date: now.add(const Duration(days: 2)),
          minTemp: 16.5,
          maxTemp: 30.5,
          condition: 'Partly Cloudy',
          humidity: 60.0,
          windSpeed: 8.5,
        ),
        ForecastDay(
          date: now.add(const Duration(days: 3)),
          minTemp: 15.0,
          maxTemp: 28.0,
          condition: 'Rainy',
          humidity: 85.0,
          windSpeed: 18.0,
        ),
      ];
    }
  }

  /// Convert WMO weather code to human-readable description
  String _getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear';
      case 1 || 2:
        return 'Partly Cloudy';
      case 3:
        return 'Overcast';
      case 45 || 48:
        return 'Foggy';
      case 51 || 53 || 55:
        return 'Drizzle';
      case 61 || 63 || 65:
        return 'Rain';
      case 71 || 73 || 75:
        return 'Snow';
      case 80 || 81 || 82:
        return 'Rain Showers';
      case 85 || 86:
        return 'Snow Showers';
      case 95 || 96 || 99:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }
}
