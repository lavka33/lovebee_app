import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';

class SideMenu extends StatelessWidget {
  final String email;
  final ScreenType currentScreen;
  final Function(ScreenType) onSelectScreen;

  const SideMenu({
    super.key,
    required this.email,
    required this.currentScreen,
    required this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/symbol.svg',
                  height: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.insights),
                  title: const Text('Data'),
                  selected: currentScreen == ScreenType.data,
                  selectedTileColor: Colors.pink.shade50,
                  onTap: () => onSelectScreen(ScreenType.data),
                ),
                ListTile(
                  leading: const Icon(Icons.hive),
                  title: const Text('Včelíny'),
                  selected: currentScreen == ScreenType.hives,
                  selectedTileColor: Colors.pink.shade50,
                  onTap: () => onSelectScreen(ScreenType.hives),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Nastavení'),
                  selected: currentScreen == ScreenType.settings,
                  selectedTileColor: Colors.pink.shade50,
                  onTap: () => onSelectScreen(ScreenType.settings),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Odhlásit se',
                  style: TextStyle(color: Colors.red),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
