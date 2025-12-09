import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main shell that provides bottom navigation for the app
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<({String path, String label, IconData icon})> _navigationItems = [
    (path: '/weather', label: 'मौसम', icon: Icons.cloud),
    (path: '/crop-planner', label: 'फसल', icon: Icons.grass),
    (path: '/mandi-price', label: 'मंडी भाव', icon: Icons.store),
    (path: '/fertilizer', label: 'खाद', icon: Icons.agriculture),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    context.go(_navigationItems[index].path);
  }

  @override
  Widget build(BuildContext context) {
    // Update selected index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    final newIndex = _navigationItems.indexWhere((item) => item.path == location);
    if (newIndex != -1 && newIndex != _selectedIndex) {
      Future.microtask(() {
        if (mounted) setState(() => _selectedIndex = newIndex);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('KrishiLite'),
        elevation: 0,
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
