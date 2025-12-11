import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/features/weather/presentation/providers/weather_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  // Punjab (Amritsar) coordinates
  final double latitude = 31.6340;
  final double longitude = 74.8711;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(weatherNotifierProvider.notifier).fetchWeather(
            latitude: latitude,
            longitude: longitude,
            location: 'Punjab, India',
          );
    });
  }

  IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('clear') || lower.contains('sunny')) return Icons.wb_sunny;
    if (lower.contains('cloudy') || lower.contains('overcast')) return Icons.cloud;
    if (lower.contains('rain') || lower.contains('drizzle')) return Icons.cloud_queue;
    if (lower.contains('snow')) return Icons.ac_unit;
    if (lower.contains('thunder')) return Icons.flash_on;
    if (lower.contains('fog')) return Icons.cloud_circle;
    return Icons.wb_sunny;
  }

  Color _getWeatherColor(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('clear') || lower.contains('sunny')) return Colors.amber;
    if (lower.contains('cloudy') || lower.contains('overcast')) return Colors.grey;
    if (lower.contains('rain') || lower.contains('drizzle')) return Colors.blue;
    if (lower.contains('snow')) return Colors.cyan;
    if (lower.contains('thunder')) return Colors.purple;
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);
    final forecastState = ref.watch(
      weatherForecastProvider((latitude, longitude)),
    );
    final localizationAsync = ref.watch(appLocalizationProvider);

    return localizationAsync.when(
      data: (localization) => RefreshIndicator(
      onRefresh: () => ref.read(weatherNotifierProvider.notifier).fetchWeather(
            latitude: latitude,
            longitude: longitude,
            location: 'Punjab, India',
          ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                localization.translate('currentWeather'),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
              ),
              const SizedBox(height: 16),

              // Current Weather Card
              weatherState.when(
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      color: Colors.green[700],
                    ),
                  ),
                ),
                error: (error, stack) => _buildErrorCard('मौसम डेटा लोड नहीं हो सका'),
                data: (weather) => _buildCurrentWeatherCard(context, weather),
              ),

              const SizedBox(height: 32),

              // Forecast Header
              Text(
                localization.translate('forecast'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
              ),
              const SizedBox(height: 16),

              // Forecast List
              forecastState.when(
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      color: Colors.green[700],
                    ),
                  ),
                ),
                error: (error, stack) => _buildErrorCard(localization.translate('error')),
                data: (forecast) => _buildForecastList(context, forecast, localization),
              ),
            ],
          ),
        ),
      ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text(localizationAsync.value?.translate('errorLoadingTranslations') ?? 'Error'))),
    );
  }

  Widget _buildCurrentWeatherCard(BuildContext context, dynamic weather) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[700]!,
            Colors.green[500]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Location
            Text(
              weather.location,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 16),

            // Temperature and Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getWeatherIcon(weather.condition),
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      weather.condition,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Weather Details Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetailColumn(
                  context,
                  'नमी',
                  '${weather.humidity.toStringAsFixed(0)}%',
                  Icons.opacity,
                ),
                _buildWeatherDetailColumn(
                  context,
                  'हवा की गति',
                  '${weather.windSpeed.toStringAsFixed(1)}',
                  Icons.air,
                ),
                _buildWeatherDetailColumn(
                  context,
                  'अपडेट',
                  DateFormat('HH:mm').format(weather.lastUpdated),
                  Icons.access_time,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildForecastList(BuildContext context, List<dynamic> forecast, dynamic localization) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final day = forecast[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date and Condition
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('d MMM, EEE').format(day.date),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        day.condition,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.green[700],
                            ),
                      ),
                    ],
                  ),
                ),

                // Icon
                Icon(
                  _getWeatherIcon(day.condition),
                  size: 40,
                  color: _getWeatherColor(day.condition),
                ),

                // Temperature Range
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${day.maxTemp.toStringAsFixed(0)}°',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600],
                          ),
                    ),
                    Text(
                      '${day.minTemp.toStringAsFixed(0)}°',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
