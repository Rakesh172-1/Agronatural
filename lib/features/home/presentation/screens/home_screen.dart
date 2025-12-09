import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vriddhiapps/core/localization/app_locale_provider.dart';
import 'package:vriddhiapps/features/weather/presentation/providers/weather_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Punjab coordinates (Amritsar)
    const double latitude = 31.6340;
    const double longitude = 74.8711;
    final weatherState = ref.watch(currentWeatherProvider((latitude, longitude)));
    final localizationAsync = ref.watch(currentLocalizationsProvider);

    return localizationAsync.when(
      data: (localization) => SingleChildScrollView(
        child: Column(
          children: [
            // Weather Section on Top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildWeatherCard(context, weatherState, localization),
            ),
            // 3 Feature Cards in Grid
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildFeatureGrid(context, localization),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const Center(child: Text('Error loading')),
    );
  }

  Widget _buildWeatherCard(BuildContext context, AsyncValue weatherState, dynamic localization) {
    return GestureDetector(
      onTap: () => context.go('/weather'),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D6A4F).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: weatherState.when(
            data: (weather) => Row(
              children: [
                // Weather Icon
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    _getWeatherIcon(weather?.condition ?? 'Clear'),
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 24),
                // Weather Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.currentWeather,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weather?.temperature?.toStringAsFixed(1) ?? '--'}°C',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather?.condition ?? localization.loading,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        localization.tapToViewDetails,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            error: (err, stack) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.cloud_off, color: Colors.white, size: 70),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      'Unable to load weather',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, dynamic localization) {
    final features = [
      (
        title: localization.mandiPrices,
        icon: Icons.store,
        color: Color(0xFF52B788),
        route: '/mandi-price',
        description: localization.checkMarketPrices
      ),
      (
        title: localization.cropPlanner,
        icon: Icons.grain,
        color: Color(0xFFFFA726),
        route: '/crop-planner',
        description: localization.planYourCrops
      ),
      (
        title: localization.fertilizer,
        icon: Icons.agriculture,
        color: Color(0xFF42A5F5),
        route: '/fertilizer',
        description: localization.fertilizerGuide
      ),
      (
        title: localization.governmentSchemes,
        icon: Icons.public,
        color: Color(0xFFD946A6),
        route: '/government-schemes',
        description: localization.viewSchemes
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: features.map((feature) {
        return _buildFeatureCard(
          context,
          feature.title,
          feature.icon,
          feature.color,
          feature.route,
          feature.description,
        );
      }).toList(),
    );
  }

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
          color: color.withValues(alpha: 0.15),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.87),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    final desc = condition.toLowerCase();
    if (desc.contains('clear') || desc.contains('sunny')) return Icons.sunny;
    if (desc.contains('cloud')) return Icons.cloud;
    if (desc.contains('rain')) return Icons.cloud_queue;
    if (desc.contains('storm') || desc.contains('thunder')) return Icons.flash_on;
    if (desc.contains('snow')) return Icons.ac_unit;
    if (desc.contains('fog') || desc.contains('mist')) return Icons.cloud_download;
    if (desc.contains('wind')) return Icons.air;
    return Icons.cloud;
  }
}
