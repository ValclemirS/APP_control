// lib/models/desgaste_data.dart
// ignore: unused_import
import 'package:flutter/material.dart';
import '../services/desgaste_service.dart';

class DesgasteData {
  int posicao;
  String gaiola;
  String forma;
  double alturaPadrao;
  double luzPadrao;
  double profundidadeCanalPadrao;
  double profundidadeCanalReal;
  double desgasteReal;
  double fatorDesgaste;
  double desgasteCalculado;
  double luzRealParou;
  double luzAjustada;
  double alturaReal;
  double diferenca;
  String situacaoLuz;
  String bitola;

  static final Map<String, Map<int, Map<String, double>>> _savedData = {};

  DesgasteData({
    required this.posicao,
    required this.gaiola,
    required this.forma,
    required this.alturaPadrao,
    required this.luzPadrao,
    required this.profundidadeCanalPadrao,
    required this.profundidadeCanalReal,
    required this.desgasteReal,
    required this.fatorDesgaste,
    required this.desgasteCalculado,
    required this.luzRealParou,
    required this.luzAjustada,
    required this.alturaReal,
    required this.diferenca,
    required this.situacaoLuz,
    required this.bitola,
  });

  factory DesgasteData.fromValues(int index, Map<String, dynamic> valores, String bitola) {
    int posicao = index + 1;
    String gaiola = valores['gaiola'] as String;
    String forma = valores['forma'] as String;
    double luzPadrao = valores['luzPadrao'] as double;
    double profundidadeCanalPadrao = valores['profundidadeCanalPadrao'] as double;
    double alturaPadrao = valores['alturaPadrao'] as double;
    double fatorDesgaste = valores['fatorDesgaste'] as double;

    final savedValues = _savedData[bitola]?[posicao] ?? {
      'profundidadeCanalReal': 0.0,
      'luzRealParou': 0.0,
      'luzAjustada': 0.0,
    };

    double profundidadeCanalReal = savedValues['profundidadeCanalReal']!;
    double luzRealParou = savedValues['luzRealParou']!;
    double luzAjustada = savedValues['luzAjustada']!;
    double desgasteReal = DesgasteService.calcularDesgasteReal(profundidadeCanalPadrao, profundidadeCanalReal);
    double desgasteCalculado = DesgasteService.calcularDesgasteCalculado(desgasteReal, fatorDesgaste);
    double alturaReal = DesgasteService.calcularAlturaReal(profundidadeCanalReal, luzAjustada);
    double diferenca = DesgasteService.calcularDiferenca(luzAjustada, luzRealParou);
    String situacaoLuz = DesgasteService.determinarSituacaoLuz(luzAjustada, luzRealParou, luzPadrao);

    return DesgasteData(
      posicao: posicao,
      gaiola: gaiola,
      forma: forma,
      alturaPadrao: alturaPadrao,
      luzPadrao: luzPadrao,
      profundidadeCanalPadrao: profundidadeCanalPadrao,
      profundidadeCanalReal: profundidadeCanalReal,
      desgasteReal: desgasteReal,
      fatorDesgaste: fatorDesgaste,
      desgasteCalculado: desgasteCalculado,
      luzRealParou: luzRealParou,
      luzAjustada: luzAjustada,
      alturaReal: alturaReal,
      diferenca: diferenca,
      situacaoLuz: situacaoLuz,
      bitola: bitola,
    );
  }

  void updateValues(double profundidadeReal, double luzRealParou, double luzAjustada, String bitola) {
    this.profundidadeCanalReal = profundidadeReal;
    this.luzRealParou = luzRealParou;
    this.luzAjustada = luzAjustada;
    this.desgasteReal = DesgasteService.calcularDesgasteReal(profundidadeCanalPadrao, profundidadeReal);
    this.desgasteCalculado = DesgasteService.calcularDesgasteCalculado(desgasteReal, fatorDesgaste);
    this.alturaReal = DesgasteService.calcularAlturaReal(profundidadeReal, luzAjustada);
    this.diferenca = DesgasteService.calcularDiferenca(luzAjustada, luzRealParou);
    this.situacaoLuz = DesgasteService.determinarSituacaoLuz(luzAjustada, luzRealParou, luzPadrao);

    if (!_savedData.containsKey(bitola)) {
      _savedData[bitola] = {};
    }
    _savedData[bitola]![posicao] = {
      'profundidadeCanalReal': profundidadeReal,
      'luzRealParou': luzRealParou,
      'luzAjustada': luzAjustada,
    };
  }
}