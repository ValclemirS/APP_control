// lib/screens/selection_screen.dart
import 'package:flutter/material.dart';
import '../config/bitola_config.dart';
import '../widgets/navigation_button.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  bool isCambioSelected = true;
  String selectedFamily = '6.30';
  String fromBitola = '6.30';
  String toBitola = '8.0';
  String selectedParadaBitola = '6.30';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção'),
        backgroundColor: const Color.fromARGB(255, 132, 164, 146),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToggleButton('Câmbio', Icons.swap_horiz, true),
                _buildToggleButton('Parada Programada', Icons.stop, false),
              ],
            ),
            const SizedBox(height: 20),
            isCambioSelected ? _buildCambioSection() : _buildParadaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isCambio) {
    return Tooltip(
      message: isCambio ? 'Alternar entre configurações' : 'Visualizar dados de parada programada',
      child: ElevatedButton.icon(
        onPressed: () => setState(() => isCambioSelected = isCambio),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isCambio == isCambioSelected
              ? const Color.fromARGB(255, 132, 164, 146)
              : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

 Widget _buildCambioSection() {
  final currentBitolas = BitolaConfig.families[selectedFamily]!;
  if (!currentBitolas.contains(fromBitola)) fromBitola = currentBitolas[0];
  if (!currentBitolas.contains(toBitola)) toBitola = currentBitolas[1];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DropdownButton<String>(
        value: selectedFamily,
        onChanged: (newValue) {
          setState(() {
            selectedFamily = newValue!;
            fromBitola = BitolaConfig.families[selectedFamily]![0];
            toBitola = BitolaConfig.families[selectedFamily]![1];
          });
        },
        items: BitolaConfig.families.keys
            .map((family) => DropdownMenuItem(
                  value: family,
                  child: Text('Família $family', style: const TextStyle(fontSize: 16)),
                ))
            .toList(),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: fromBitola,
              onChanged: (newValue) => setState(() => fromBitola = newValue!),
              items: currentBitolas
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(BitolaConfig.bitolaDisplay[value] ?? '$value mm',
                            style: const TextStyle(fontSize: 16)),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: toBitola,
              onChanged: (newValue) => setState(() => toBitola = newValue!),
              items: currentBitolas
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(BitolaConfig.bitolaDisplay[value] ?? '$value mm',
                            style: const TextStyle(fontSize: 16)),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Câmbio do ${BitolaConfig.bitolaDisplay[fromBitola]} para o ${BitolaConfig.bitolaDisplay[toBitola]}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          NavigationButton(text: 'Controle', filtro: 'Laminador', bitola: toBitola),
        ],
      ),
    ],
  );
}
  Widget _buildParadaSection() {
    final allBitolas = BitolaConfig.families.values.expand((bitolas) => bitolas).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parada Programada', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
        const SizedBox(height: 20),
        DropdownButton<String>(
          value: selectedParadaBitola,
          onChanged: (newValue) => setState(() => selectedParadaBitola = newValue!),
          items: allBitolas
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(BitolaConfig.bitolaDisplay[value] ?? '$value mm',
                        style: const TextStyle(fontSize: 16)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        NavigationButton(text: 'Laminador (1-18)', filtro: 'Laminador', bitola: selectedParadaBitola),
        const SizedBox(height: 10),
        NavigationButton(
            text: 'Bloco Laminador (18-28)', filtro: 'Bloco Laminador', bitola: selectedParadaBitola),
      ],
    );
  }
}