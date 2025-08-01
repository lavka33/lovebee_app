import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Zde budou data z úlu 🐝',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
