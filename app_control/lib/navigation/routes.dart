// lib/navigation/routes.dart
import 'package:flutter/material.dart';
import '../screens/selection_screen.dart';
import '../screens/controle_desgaste_screen.dart';

class AppRoutes {
  static const String selection = '/selection';
  static const String controleDesgaste = '/controle_desgaste';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      selection: (context) => const SelectionScreen(),
      controleDesgaste: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
        return ControleDesgasteScreen(
          filtro: args?['filtro'] ?? 'Geral',
          bitola: args?['bitola'] ?? '6.30',
        );
      },
    };
  }

  static void navigateToControleDesgaste(BuildContext context, String filtro, String bitola) {
    Navigator.pushNamed(
      context,
      controleDesgaste,
      arguments: {'filtro': filtro, 'bitola': bitola},
    );
  }
}