import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';
import 'package:vriddhiapps/features/weather/presentation/providers/weather_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Punjab coordinates (Amritsar)
    const double latitude = 31.6340;
    const double longitude = 74.8711;

    final weatherState = ref.watch(currentWeatherProvider((latitude, longitude)));
    final localizationAsync = ref.watch(appLocalizationProvider);

    return localizationAsync.when(
      data: (localization) => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildWeatherCard(context, weatherState, localization),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildFeatureGrid(context, localization),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading')),
    );
  }

  // ---------------- WEATHER CARD ----------------
  Widget _buildWeatherCard(
      BuildContext context, AsyncValue weatherState, dynamic localization) {
    return GestureDetector(
      onTap: () {
        // Show weather notification/alert before navigating
        weatherState.whenData((weather) {
          if (weather != null) {
            _showWeatherNotification(context, weather, localization);
          }
        });
        // Navigate to weather screen after short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          context.go('/weather');
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: weatherState.when(
            data: (weather) => Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _getWeatherIcon(weather?.condition ?? "Clear"),
                    size: 55, // reduced
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),

                // Weather text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate("currentWeather"),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${weather?.temperature?.toStringAsFixed(1) ?? '--'}°C",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weather?.condition ?? "Loading...",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Colors.white),
            )),
            error: (_, __) => const Text(
              "Unable to load weather",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- GRID ----------------
  Widget _buildFeatureGrid(BuildContext context, dynamic localization) {
    final features = [
      (
        title: localization.translate('mandiPrices'),
        icon: Icons.currency_rupee_rounded,
        color: const Color(0xFF52B788),
        route: '/mandi-price',
        description: localization.translate('checkMarketPrices')
      ),
      (
        title: localization.translate('cropPlanner'),
        icon: Icons.agriculture_outlined,
        color: const Color(0xFFFFA726),
        route: '/crop-planner',
        description: localization.translate('planYourCrops')
      ),
      (
        title: localization.translate('fertilizerNav'),
        icon: Icons.water_drop_outlined,
        color: const Color(0xFF42A5F5),
        route: '/fertilizer',
        description: localization.translate('fertilizerGuide')
      ),
      (
        title: localization.translate('governmentSchemes'),
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFFD946A6),
        route: '/government-schemes',
        description: localization.translate('viewSchemes')
      ),
      (
        title: localization.translate('blog'),
        icon: Icons.menu_book_outlined,
        color: const Color(0xFF66BB6A),
        route: '/blog',
        description: localization.translate('blogDescription')
      ),
      (
        title: localization.translate('farmCalculator'),
        icon: Icons.calculate_outlined,
        color: const Color(0xFF78909C),
        route: '/calculator',
        description: localization.translate('calculateFarmMetrics')
      ),
      (
        title: localization.translate('loanSchemes'),
        icon: Icons.savings_outlined,
        color: const Color(0xFF8D6E63),
        route: '/loan-schemes',
        description: localization.translate('loanSchemesDescription')
      ),
      (
        title: localization.translate('diseaseDetector'),
        icon: Icons.health_and_safety_outlined,
        color: const Color(0xFFEF5350),
        route: '/disease-detector',
        description: localization.translate('diseaseDetectorDescription')
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1,
      children: features.map((f) {
        return _buildFeatureCard(
          context,
          f.title,
          f.icon,
          f.color,
          f.route,
          f.description,
        );
      }).toList(),
    );
  }

  // ---------------- FEATURE CARD ----------------
  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
    String description,
  ) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WEATHER NOTIFICATION ----------------
  void _showWeatherNotification(
      BuildContext context, dynamic weather, dynamic localization) {
    // Generate weather alert message
    String alertMessage = _generateWeatherAlert(weather, localization);
    Color alertColor = _getAlertColor(weather);
    IconData alertIcon = _getAlertIcon(weather);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(alertIcon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${localization.translate('weather')} Update',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alertMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: alertColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // ---------------- GENERATE WEATHER ALERT ----------------
  String _generateWeatherAlert(dynamic weather, dynamic localization) {
    final temp = weather.temperature;
    final condition = weather.condition.toLowerCase();
    final humidity = weather.humidity;

    // Temperature alerts
    if (temp > 35) {
      return '🌡️ High Temperature Alert - ${temp.toStringAsFixed(1)}°C! Stay hydrated and avoid midday farming.';
    } else if (temp < 10) {
      return '❄️ Cold Weather Alert - ${temp.toStringAsFixed(1)}°C! Protect sensitive crops from frost.';
    }

    // Rain alerts
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return '☔ Rain Expected! Postpone spraying and irrigation. Good for sowing.';
    }

    // Storm/Thunder alerts
    if (condition.contains('storm') || condition.contains('thunder')) {
      return '⚡ Thunderstorm Warning! Stay indoors and secure farm equipment.';
    }

    // High humidity alerts
    if (humidity > 80) {
      return '💧 High Humidity - ${humidity.toStringAsFixed(0)}%! Monitor crops for fungal diseases.';
    }

    // Good weather
    if (condition.contains('clear') || condition.contains('sunny')) {
      return '☀️ Perfect Farming Weather! ${temp.toStringAsFixed(1)}°C - Ideal for field work.';
    }

    // Default
    return '${weather.condition} - ${temp.toStringAsFixed(1)}°C, ${localization.translate('humidity')}: ${humidity.toStringAsFixed(0)}%';
  }

  // ---------------- ALERT COLOR ----------------
  Color _getAlertColor(dynamic weather) {
    final temp = weather.temperature;
    final condition = weather.condition.toLowerCase();

    if (temp > 35) return Colors.red.shade700;
    if (temp < 10) return Colors.blue.shade700;
    if (condition.contains('rain')) return Colors.blue.shade600;
    if (condition.contains('storm') || condition.contains('thunder')) {
      return Colors.deepPurple.shade700;
    }
    if (condition.contains('clear') || condition.contains('sunny')) {
      return Colors.green.shade700;
    }
    return const Color(0xFF2D6A4F);
  }

  // ---------------- ALERT ICON ----------------
  IconData _getAlertIcon(dynamic weather) {
    final temp = weather.temperature;
    final condition = weather.condition.toLowerCase();

    if (temp > 35) return Icons.thermostat;
    if (temp < 10) return Icons.ac_unit;
    if (condition.contains('rain')) return Icons.umbrella;
    if (condition.contains('storm') || condition.contains('thunder')) {
      return Icons.flash_on;
    }
    if (condition.contains('clear') || condition.contains('sunny')) {
      return Icons.wb_sunny;
    }
    return Icons.notifications_active;
  }

  // ---------------- WEATHER ICON HELPER ----------------
  IconData _getWeatherIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('clear') || c.contains('sunny')) return Icons.sunny;
    if (c.contains('cloud')) return Icons.cloud;
    if (c.contains('rain')) return Icons.cloud_queue;
    if (c.contains('storm') || c.contains('thunder')) return Icons.flash_on;
    if (c.contains('snow')) return Icons.ac_unit;
    if (c.contains('fog') || c.contains('mist')) return Icons.cloud_circle;
    if (c.contains('wind')) return Icons.air;
    return Icons.cloud;
  }
}
