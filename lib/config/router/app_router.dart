import 'package:go_router/go_router.dart';
import 'package:vriddhiapps/features/weather/presentation/screens/weather_screen.dart';
import 'package:vriddhiapps/features/crop_planner/presentation/screens/crop_planner_screen.dart';
import 'package:vriddhiapps/features/mandi_price/presentation/screens/mandi_price_screen.dart';
import 'package:vriddhiapps/features/fertilizer/presentation/screens/fertilizer_screen.dart';

/// Router configuration for the app
final appRouter = GoRouter(
  initialLocation: '/weather',
  routes: [
    GoRoute(
      path: '/weather',
      name: 'weather',
      builder: (context, state) => const WeatherScreen(),
    ),
    GoRoute(
      path: '/crop-planner',
      name: 'crop-planner',
      builder: (context, state) => const CropPlannerScreen(),
    ),
    GoRoute(
      path: '/mandi-price',
      name: 'mandi-price',
      builder: (context, state) => const MandiPriceScreen(),
    ),
    GoRoute(
      path: '/fertilizer',
      name: 'fertilizer',
      builder: (context, state) => const FertilizerScreen(),
    ),
  ],
);
