// lib/main.dart
import 'package:flutter/material.dart';
import 'navigation/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Desgaste',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 132, 164, 146),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.selection,
      routes: AppRoutes.getRoutes(),
    );
  }
}