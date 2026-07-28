import 'package:flutter/material.dart';
import 'colombia_screen.dart';
import 'regions_screen.dart';
import 'attractions_screen.dart';
import 'iss_screen.dart';
import 'weather_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ColombiaScreen(),
    const RegionsScreen(),
    const AttractionsScreen(),
    const IssScreen(),
    const WeatherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              extended: isWide,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() => _selectedIndex = index);
              },
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: FlutterLogo(size: 40),
              ),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.flag), label: Text('Colombia')),
                NavigationRailDestination(
                    icon: Icon(Icons.map), label: Text('Regiones')),
                NavigationRailDestination(
                    icon: Icon(Icons.photo_album), label: Text('Turismo')),
                NavigationRailDestination(
                    icon: Icon(Icons.rocket_launch),
                    label: Text('Estación ISS')),
                NavigationRailDestination(
                    icon: Icon(Icons.cloud), label: Text('Clima')),
              ],
            ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: !isWide
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              onTap: (index) => setState(() => _selectedIndex = index),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.flag), label: 'Colombia'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.map), label: 'Regiones'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.photo_album), label: 'Turismo'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.rocket_launch), label: 'ISS'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.cloud), label: 'Clima'),
              ],
            )
          : null,
    );
  }
}
