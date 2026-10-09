import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_tokens.dart';

class AppTheme {
  static ThemeData get claro => _construir(Brightness.light);
  static ThemeData get oscuro => _construir(Brightness.dark);

  static ThemeData _construir(Brightness brillo) {
    final esOscuro = brillo == Brightness.dark;
    final fondo = esOscuro ? AppColors.noche : AppColors.papel;
    final superficie = esOscuro ? AppColors.nocheSuperficie : AppColors.hoja;
    final texto = esOscuro ? AppColors.papel : AppColors.tinta;
    final primario = esOscuro ? AppColors.ocre : AppColors.terracota;
    final sobrePrimario = esOscuro ? AppColors.tinta : AppColors.papel;

    final esquema = ColorScheme(
      brightness: brillo,
      primary: primario,
      onPrimary: sobrePrimario,
      secondary: AppColors.musgo,
      onSecondary: AppColors.papel,
      error: esOscuro ? const Color(0xFFE88B7A) : const Color(0xFF9E2B25),
      onError: esOscuro ? AppColors.tinta : Colors.white,
      surface: superficie,
      onSurface: texto,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: esquema);

    TextStyle serif(double size, FontWeight peso) =>
        GoogleFonts.fraunces(fontSize: size, fontWeight: peso, color: texto, height: 1.1);

    final textos = base.textTheme
        .apply(fontFamily: GoogleFonts.workSans().fontFamily, bodyColor: texto, displayColor: texto)
        .copyWith(
          displaySmall: serif(38, FontWeight.w600),
          headlineMedium: serif(28, FontWeight.w600),
          headlineSmall: serif(22, FontWeight.w600),
          titleLarge: serif(20, FontWeight.w600),
        );

    final bordeSuave = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: texto.withValues(alpha: 0.12)),
    );

    return base.copyWith(
      scaffoldBackgroundColor: fondo,
      textTheme: textos,
      appBarTheme: AppBarTheme(
        backgroundColor: fondo,
        foregroundColor: texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: serif(24, FontWeight.w700),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: GoogleFonts.workSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: texto,
          side: BorderSide(color: texto.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: GoogleFonts.workSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: superficie,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: bordeSuave,
        enabledBorder: bordeSuave,
        focusedBorder: bordeSuave.copyWith(borderSide: BorderSide(color: primario, width: 1.6)),
        labelStyle: TextStyle(color: texto.withValues(alpha: 0.7)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: esOscuro ? AppColors.papel : AppColors.tinta,
        contentTextStyle: GoogleFonts.workSans(color: esOscuro ? AppColors.tinta : AppColors.papel),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      dividerTheme: DividerThemeData(color: texto.withValues(alpha: 0.1), thickness: 1),
    );
  }
}