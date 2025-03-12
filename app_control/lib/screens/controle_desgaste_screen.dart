// lib/screens/controle_desgaste_screen.dart
import 'package:flutter/material.dart';
import '../config/bitola_config.dart';
import '../models/desgaste_data.dart';
import '../widgets/desgaste_data_grid.dart'; // Importa os widgets modulares

class ControleDesgasteScreen extends StatefulWidget {
  final String filtro;
  final String bitola;

  const ControleDesgasteScreen({required this.filtro, required this.bitola, super.key});

  @override
  _ControleDesgasteScreenState createState() => _ControleDesgasteScreenState();
}

class _ControleDesgasteScreenState extends State<ControleDesgasteScreen> {
  List<DesgasteData> dados = [];
  List<DesgasteData> dadosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    final valoresBitola = BitolaConfig.valoresPadrao[widget.bitola];
    if (valoresBitola == null || valoresBitola.length < 28) {
      throw Exception('Dados insuficientes para a bitola ${widget.bitola}. Esperado: 28 posições.');
    }
    dados = List.generate(
      28,
      (index) => DesgasteData.fromValues(index, valoresBitola[index], widget.bitola),
    );
    _aplicarFiltro(widget.filtro);
  }

  void _aplicarFiltro(String filtro) {
    setState(() {
      if (filtro == 'Laminador') {
        dadosFiltrados = dados.where((dado) => dado.posicao >= 1 && dado.posicao <= 18).toList();
      } else if (filtro == 'Bloco Laminador') {
        dadosFiltrados = dados.where((dado) => dado.posicao >= 18 && dado.posicao <= 28).toList();
      } else {
        dadosFiltrados = dados; // 'Geral' ou outro valor padrão
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Desgaste - ${widget.bitola} mm'),
        backgroundColor: const Color.fromARGB(255, 132, 164, 146),
      ),
      body: DesgasteDataGrid(
        dadosFiltrados: dadosFiltrados,
        onEdit: (index) => _editarDados(index),
      ),
    );
  }

  void _editarDados(int index) {
    showDialog(
      context: context,
      builder: (context) => EditDataDialog(
        data: dadosFiltrados[index],
        onSave: (updatedData) {
          setState(() {
            dadosFiltrados[index] = updatedData;
            updatedData.updateValues(
              updatedData.profundidadeCanalReal,
              updatedData.luzRealParou,
              updatedData.luzAjustada,
              widget.bitola,
            );
          });
        },
      ),
    );
  }
}