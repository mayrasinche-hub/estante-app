import 'package:flutter/material.dart';

import 'app_tokens.dart';

class PaletaLomo {
  static const _colores = [
    Color(0xFFA8432F),
    Color(0xFF4F6A48),
    Color(0xFFE0A458),
    Color(0xFF2E4A62),
    Color(0xFF7A3E48),
    Color(0xFF3F6E6A),
    Color(0xFF9A6440),
    Color(0xFF4B4E6D),
  ];

  static int semilla(String texto) {
    var h = 7;
    for (final c in texto.trim().toLowerCase().codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return h;
  }

  static Color color(String titulo) => _colores[semilla(titulo) % _colores.length];

  static Color textoSobre(Color fondo) {
    final l = fondo.computeLuminance();
    final conPapel = (AppColors.papel.computeLuminance() + 0.05) / (l + 0.05);
    final conTinta = (l + 0.05) / (AppColors.tinta.computeLuminance() + 0.05);
    return conPapel >= conTinta ? AppColors.papel : AppColors.tinta;
  }
}