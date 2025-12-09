import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vriddhiapps/core/theme/app_theme.dart';
import 'package:vriddhiapps/features/home/presentation/screens/home_screen.dart';
import 'package:vriddhiapps/features/weather/presentation/screens/weather_screen.dart';
import 'package:vriddhiapps/features/crop_planner/presentation/screens/crop_planner_screen.dart';
import 'package:vriddhiapps/features/mandi_price/presentation/screens/mandi_price_screen.dart';
import 'package:vriddhiapps/features/fertilizer/presentation/screens/fertilizer_screen.dart';
import 'package:vriddhiapps/features/government_schemes/presentation/screens/government_schemes_screen.dart';
import 'package:vriddhiapps/features/blog/presentation/screens/blog_screen.dart';
import 'package:vriddhiapps/features/farm_calculator/presentation/screens/calculator_screen.dart';
import 'package:vriddhiapps/features/loan_schemes/presentation/screens/loan_schemes_screen.dart';
import 'package:vriddhiapps/features/disease_detector/presentation/screens/disease_detector_screen.dart';
import 'package:vriddhiapps/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:vriddhiapps/features/auth/presentation/screens/sign_up_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vriddhi',
      theme: AppTheme.lightTheme,
      routerConfig: _buildRouter(),
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/sign-in',
      routes: [
        // Auth routes (no ShellRoute) - Always show first
        GoRoute(
          path: '/sign-in',
          name: 'sign-in',
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: '/sign-up',
          name: 'sign-up',
          builder: (context, state) => const SignUpScreen(),
        ),
        // Main app routes with ShellRoute
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
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
            GoRoute(
              path: '/government-schemes',
              name: 'government-schemes',
              builder: (context, state) => const GovernmentSchemesScreen(),
            ),
            GoRoute(
              path: '/blog',
              name: 'blog',
              builder: (context, state) => const BlogScreen(),
            ),
            GoRoute(
              path: '/calculator',
              name: 'calculator',
              builder: (context, state) => const FarmCalculatorScreen(),
            ),
            GoRoute(
              path: '/loan-schemes',
              name: 'loan-schemes',
              builder: (context, state) => const LoanSchemesScreen(),
            ),
            GoRoute(
              path: '/disease-detector',
              name: 'disease-detector',
              builder: (context, state) => const DiseaseDetectorScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;

  final navigationItems = [
    (path: '/', label: 'Home', icon: Icons.home),
    (path: '/weather', label: 'Weather', icon: Icons.cloud),
    (path: '/crop-planner', label: 'Planner', icon: Icons.grass),
    (path: '/mandi-price', label: 'Prices', icon: Icons.store),
    (path: '/fertilizer', label: 'Fertilizer', icon: Icons.agriculture),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vriddhi'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        items: navigationItems.map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.label)).toList(),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          context.go(navigationItems[index].path);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final newIndex = navigationItems.indexWhere((item) => item.path == location);
    if (newIndex != -1 && newIndex != _selectedIndex) {
      Future.microtask(() {
        if (mounted) setState(() => _selectedIndex = newIndex);
      });
    }
    return widget.child;
  }
}