// lib/widgets/desgaste_data_grid.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/desgaste_data.dart';
import '../services/desgaste_service.dart';

class DesgasteDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  DesgasteDataSource(List<DesgasteData> dados) {
    _rows = dados.map((dado) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'Posição', value: dado.posicao),
      DataGridCell<String>(columnName: 'Gaiola', value: dado.gaiola),
      DataGridCell<String>(columnName: 'Forma', value: dado.forma),
      DataGridCell<double>(columnName: 'Altura Padrão', value: dado.alturaPadrao),
      DataGridCell<double>(columnName: 'Luz Padrão', value: dado.luzPadrao),
      DataGridCell<double>(columnName: 'Profundidade Canal Padrão', value: dado.profundidadeCanalPadrao),
      DataGridCell<double>(columnName: 'Profundidade Canal Real', value: dado.profundidadeCanalReal),
      DataGridCell<double>(columnName: 'Desgaste Real', value: dado.desgasteReal),
      DataGridCell<double>(columnName: 'Fator de Desgaste', value: dado.fatorDesgaste),
      DataGridCell<double>(columnName: 'Desgaste Calculado', value: dado.desgasteCalculado),
      DataGridCell<double>(columnName: 'Luz Real Parou', value: dado.luzRealParou),
      DataGridCell<double>(columnName: 'Luz Ajustada', value: dado.luzAjustada),
      DataGridCell<double>(columnName: 'Altura Real', value: dado.alturaReal),
      DataGridCell<double>(columnName: 'Diferença', value: dado.diferenca),
      DataGridCell<String>(columnName: 'Situação da Luz', value: dado.situacaoLuz),
    ])).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((dataGridCell) {
        String displayValue = dataGridCell.value is double
            ? (dataGridCell.value as double).toStringAsFixed(2)
            : dataGridCell.value.toString();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(displayValue),
        );
      }).toList(),
    );
  }
}

class DesgasteDataGrid extends StatelessWidget {
  final List<DesgasteData> dadosFiltrados;
  final Function(int) onEdit;

  const DesgasteDataGrid({required this.dadosFiltrados, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: DesgasteDataSource(dadosFiltrados),
      columns: [
        GridColumn(columnName: 'Posição', label: const Text('Posição')),
        GridColumn(columnName: 'Gaiola', label: const Text('Gaiola')),
        GridColumn(columnName: 'Forma', label: const Text('Forma')),
        GridColumn(columnName: 'Altura Padrão', label: const Text('Altura Padrão (mm)')),
        GridColumn(columnName: 'Luz Padrão', label: const Text('Luz Padrão (mm)')),
        GridColumn(columnName: 'Profundidade Canal Padrão', label: const Text('Profundidade Canal Padrão (mm)')),
        GridColumn(columnName: 'Profundidade Canal Real', label: const Text('Profundidade Canal Real (mm)')),
        GridColumn(columnName: 'Desgaste Real', label: const Text('Desgaste Real (mm)')),
        GridColumn(columnName: 'Fator de Desgaste', label: const Text('Fator de Desgaste (%)')),
        GridColumn(columnName: 'Desgaste Calculado', label: const Text('Desgaste Calculado (mm)')),
        GridColumn(columnName: 'Luz Real Parou', label: const Text('Luz Real Parou (mm)')),
        GridColumn(columnName: 'Luz Ajustada', label: const Text('Luz Ajustada (mm)')),
        GridColumn(columnName: 'Altura Real', label: const Text('Altura Real (mm)')),
        GridColumn(columnName: 'Diferença', label: const Text('Diferença (mm)')),
        GridColumn(columnName: 'Situação da Luz', label: const Text('Situação da Luz')),
      ],
      onCellTap: (details) {
        if (details.rowColumnIndex.rowIndex > 0) {
          onEdit(details.rowColumnIndex.rowIndex - 1);
        }
      },
    );
  }
}

class EditDataDialog extends StatefulWidget {
  final DesgasteData data;
  final Function(DesgasteData) onSave;

  const EditDataDialog({required this.data, required this.onSave, super.key});

  @override
  _EditDataDialogState createState() => _EditDataDialogState();
}

class _EditDataDialogState extends State<EditDataDialog> {
  late TextEditingController profundidadeRealController;
  late TextEditingController luzRealParouController;
  late TextEditingController luzAjustadaController;
  String? _previousLuzAjustada;

  @override
  void initState() {
    super.initState();
    profundidadeRealController =
        TextEditingController(text: widget.data.profundidadeCanalReal.toStringAsFixed(2));
    luzRealParouController = TextEditingController(text: widget.data.luzRealParou.toStringAsFixed(2));
    luzAjustadaController = TextEditingController(text: widget.data.luzAjustada.toStringAsFixed(2));
    _previousLuzAjustada = luzAjustadaController.text;

    profundidadeRealController.addListener(_calcularLuzAjustada);
    luzRealParouController.addListener(_atualizarSituacaoLuz);
  }

  void _calcularLuzAjustada() {
    double profundidadeReal = double.tryParse(profundidadeRealController.text) ?? 0.0;
    if (profundidadeReal >= 0) {
      double luzAjustada = widget.data.alturaPadrao - (profundidadeReal * 2);
      setState(() {
        _previousLuzAjustada = luzAjustadaController.text;
        luzAjustadaController.text = luzAjustada.toStringAsFixed(2);
      });
      _atualizarSituacaoLuz();
    }
  }

  void _atualizarSituacaoLuz() {
    double luzAjustada = double.tryParse(luzAjustadaController.text) ?? 0.0;
    double luzRealParou = double.tryParse(luzRealParouController.text) ?? 0.0;

    widget.data.situacaoLuz = DesgasteService.determinarSituacaoLuz(
      luzAjustada,
      luzRealParou,
      widget.data.luzPadrao,
    );

    setState(() {});
  }

  @override
  void dispose() {
    profundidadeRealController.removeListener(_calcularLuzAjustada);
    luzRealParouController.removeListener(_atualizarSituacaoLuz);
    profundidadeRealController.dispose();
    luzRealParouController.dispose();
    luzAjustadaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Dados - Posição ${widget.data.posicao}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: profundidadeRealController,
              decoration: const InputDecoration(
                labelText: 'Profundidade Canal Real (mm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: luzRealParouController,
              decoration: const InputDecoration(
                labelText: 'Luz Real Parou (mm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: luzAjustadaController.text != _previousLuzAjustada
                  ? Colors.yellow.withOpacity(0.3)
                  : Colors.transparent,
              child: TextField(
                controller: luzAjustadaController,
                decoration: const InputDecoration(
                  labelText: 'Luz Ajustada (mm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
            ),
            const SizedBox(height: 16),
            Text('Situação da Luz: ${widget.data.situacaoLuz}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            double profundidadeReal = double.tryParse(profundidadeRealController.text) ?? 0.0;
            double luzRealParou = double.tryParse(luzRealParouController.text) ?? 0.0;
            double luzAjustada = double.tryParse(luzAjustadaController.text) ?? 0.0;

            if (profundidadeReal < 0 || luzRealParou < 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Valores inválidos'), backgroundColor: Colors.red),
              );
              return;
            }

            widget.data.updateValues(profundidadeReal, luzRealParou, luzAjustada, widget.data.bitola);
            widget.onSave(widget.data);
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}