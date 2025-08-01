import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/side_menu.dart';
import 'screens/data_screen.dart';
import 'screens/hives_screen.dart';
import 'screens/settings_screen.dart';

enum ScreenType { data, hives, settings }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScreenType _currentScreen = ScreenType.data;

  void _selectScreen(ScreenType screen) {
    setState(() {
      _currentScreen = screen;
      Navigator.pop(context); // zavře Drawer
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentScreen) {
      case ScreenType.hives:
        return const HivesScreen();
      case ScreenType.settings:
        return const SettingsScreen();
      case ScreenType.data:
      default:
        return const DataScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LoveBee'),
      ),
      drawer: SideMenu(
        email: user?.email ?? '',
        currentScreen: _currentScreen,
        onSelectScreen: _selectScreen,
      ),
      body: _getCurrentScreen(),
    );
  }
}
