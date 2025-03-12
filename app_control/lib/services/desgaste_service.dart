// lib/services/desgaste_service.dart
class DesgasteService {
  static double calcularDesgasteReal(double profundidadePadrao, double profundidadeReal) {
    return profundidadePadrao - profundidadeReal;
  }

  static double calcularAlturaReal(double profundidadeReal, double luzAjustada) {
    return (profundidadeReal * 2) + luzAjustada;
  }

  static double calcularDesgasteCalculado(double desgasteReal, double fatorDesgaste) {
    return fatorDesgaste * desgasteReal;
  }

  static double calcularDiferenca(double luzAjustada, double luzRealParou) {
    return luzAjustada - luzRealParou;
  }

  static String determinarSituacaoLuz(double luzAjustada, double luzRealParou, double luzPadrao) {
    if (luzAjustada > luzRealParou) return 'Trocar Canal';
    if (luzAjustada < luzPadrao) return 'Abrir';
    if (luzAjustada > luzPadrao) return 'Fechar';
    return 'Manter';
  }
}