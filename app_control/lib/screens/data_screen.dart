import 'package:flutter/material.dart';
import 'controle_desgaste_screen.dart';

class DataScreen extends StatelessWidget {
  final String bitola;

  DataScreen({required this.bitola});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados - $bitola mm'),
        backgroundColor: Color.fromARGB(255, 132, 164, 146),
      ),
      body: ControleDesgasteScreen(filtro: 'Geral', bitola: bitola),
    );
  }
}