import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vriddhiapps/features/weather/presentation/providers/weather_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  int selectedForecastIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double latitude = 31.6340;
    const double longitude = 74.8711;
    
    final weatherState = ref.watch(currentWeatherProvider((latitude, longitude)));
    final forecastState = ref.watch(weatherForecastProvider((latitude, longitude)));

    return weatherState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (weather) => forecastState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (forecast) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  weather.location,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 28,
                  ),
                ),
              ),

              // Main Weather Card (Large Temperature)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildMainWeatherCard(context, weather),
              ),
              const SizedBox(height: 24),

              // Weather Condition & Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildWeatherDetails(context, weather),
              ),
              const SizedBox(height: 24),

              // Hourly Forecast
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Hourly',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildHourlyForecast(context, forecast),
              const SizedBox(height: 24),

              // 5-Day Forecast with Selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '5-Day Forecast',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildFiveDayForecast(context, forecast),
              const SizedBox(height: 24),

              // Selected Day Details (5-Year Data Equivalent)
              if (selectedForecastIndex < forecast.length)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildSelectedDayDetails(context, forecast[selectedForecastIndex]),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainWeatherCard(BuildContext context, dynamic weather) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather Icon & Temp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                _getWeatherIcon(weather.condition),
                size: 60,
                color: Colors.white70,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(0)}°',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    weather.condition,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Min/Max Temp
          Text(
            'Min ${weather.minTemp.toStringAsFixed(0)}° / Max ${weather.maxTemp.toStringAsFixed(0)}°',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(BuildContext context, dynamic weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDetailBox(
          context,
          'Humidity',
          '${weather.humidity.toStringAsFixed(0)}%',
          Icons.opacity,
        ),
        _buildDetailBox(
          context,
          'Wind Speed',
          '${weather.windSpeed.toStringAsFixed(1)} m/s',
          Icons.air,
        ),
        _buildDetailBox(
          context,
          'Pressure',
          '1013 hPa',
          Icons.compress,
        ),
      ],
    );
  }

  Widget _buildDetailBox(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white60, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast(BuildContext context, List<dynamic> forecast) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 6,
        itemBuilder: (context, index) {
          // Generate hourly data
          final now = DateTime.now();
          final hourTime = now.add(Duration(hours: index));
          final hour = hourTime.hour;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Text(
                  '${hour > 12 ? hour - 12 : hour}:00 ${hour >= 12 ? 'pm' : 'am'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  _getWeatherIcon('Cloudy'),
                  color: Colors.yellow[600],
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  '${20 - index}°',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiveDayForecast(BuildContext context, List<dynamic> forecast) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final day = forecast[index];
          final date = DateTime.now().add(Duration(days: index));
          final dayName = DateFormat('E').format(date);
          
          return GestureDetector(
            onTap: () => setState(() => selectedForecastIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selectedForecastIndex == index 
                  ? Colors.blue[600]
                  : Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedForecastIndex == index 
                    ? Colors.blue[400]!
                    : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    _getWeatherIcon(day.condition),
                    color: Colors.yellow[600],
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.maxTemp.toStringAsFixed(0)}°',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedDayDetails(BuildContext context, dynamic day) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDetailBox(
                context,
                'High',
                '${day.maxTemp.toStringAsFixed(0)}°',
                Icons.arrow_upward,
              ),
              _buildDetailBox(
                context,
                'Low',
                '${day.minTemp.toStringAsFixed(0)}°',
                Icons.arrow_downward,
              ),
              _buildDetailBox(
                context,
                'Condition',
                day.condition,
                _getWeatherIcon(day.condition),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Icons.sunny;
      case 'cloudy':
      case 'partly cloudy':
        return Icons.cloud;
      case 'rainy':
      case 'rain':
        return Icons.cloud_queue;
      case 'stormy':
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snowy':
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.cloud;
    }
  }
}
