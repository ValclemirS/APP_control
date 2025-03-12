// lib/widgets/navigation_button.dart
import 'package:flutter/material.dart';
import '../navigation/routes.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  final String filtro;
  final String bitola;
  final VoidCallback? onPressed;

  const NavigationButton({
    required this.text,
    required this.filtro,
    required this.bitola,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ??
          () => AppRoutes.navigateToControleDesgaste(context, filtro, bitola),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 132, 164, 146),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}