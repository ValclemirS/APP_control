import 'package:flutter/material.dart';
import 'controle_desgaste_screen.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<String> bitolas = ['6.30', '8', '12.5', '16', '20'];
  String selectedBitola = '6.30';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navegação'),
        backgroundColor: const Color.fromARGB(255, 132, 164, 146),
      ),
      body: Center(
        child: NavigationCard(
          bitolas: bitolas,
          selectedBitola: selectedBitola,
          onBitolaChanged: (newValue) {
            setState(() {
              selectedBitola = newValue!;
            });
          },
        ),
      ),
    );
  }
}

class NavigationCard extends StatelessWidget {
  final List<String> bitolas;
  final String selectedBitola;
  final ValueChanged<String?> onBitolaChanged;

  NavigationCard({
    required this.bitolas,
    required this.selectedBitola,
    required this.onBitolaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: selectedBitola,
              onChanged: onBitolaChanged,
              items: bitolas
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value mm', style: TextStyle(fontSize: 16)),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            NavigationButton(
              text: 'Laminador (1-18)',
              filtro: 'Laminador',
              bitola: selectedBitola,
            ),
            SizedBox(height: 10),
            NavigationButton(
              text: 'Bloco Laminador (18-28)',
              filtro: 'Bloco Laminador',
              bitola: selectedBitola,
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String text;
  final String filtro;
  final String bitola;

  NavigationButton({
    required this.text,
    required this.filtro,
    required this.bitola,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ControleDesgasteScreen(
              filtro: filtro,
              bitola: bitola,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 132, 164, 146),
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}