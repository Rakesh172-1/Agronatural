import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/weather/data/models/weather_model.dart';
import 'package:vriddhiapps/features/weather/data/services/weather_service.dart';

/// Provider for WeatherService singleton
final weatherServiceProvider = Provider((ref) => WeatherService());

/// Provider for current weather - returns Weather object
final currentWeatherProvider = FutureProvider.family<Weather, (double, double)>(
  (ref, coordinates) async {
    final service = ref.watch(weatherServiceProvider);
    return service.getCurrentWeather(
      latitude: coordinates.$1,
      longitude: coordinates.$2,
    );
  },
);

/// Provider for weather forecast - returns List of ForecastDay objects
final weatherForecastProvider =
    FutureProvider.family<List<ForecastDay>, (double, double)>(
  (ref, coordinates) async {
    final service = ref.watch(weatherServiceProvider);
    return service.getForecast(
      latitude: coordinates.$1,
      longitude: coordinates.$2,
    );
  },
);

/// StateNotifier for managing weather state
class WeatherNotifier extends StateNotifier<AsyncValue<Weather>> {
  WeatherNotifier(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  Future<void> fetchWeather({
    required double latitude,
    required double longitude,
    required String location,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(weatherServiceProvider);
      return service.getCurrentWeather(
        latitude: latitude,
        longitude: longitude,
        location: location,
      );
    });
  }
}

/// StateNotifierProvider for weather
final weatherNotifierProvider =
    StateNotifierProvider.autoDispose<WeatherNotifier, AsyncValue<Weather>>(
  (ref) => WeatherNotifier(ref),
);
