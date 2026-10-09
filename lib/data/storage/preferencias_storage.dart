import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasStorage {
  PreferenciasStorage([SharedPreferencesAsync? prefs])
      : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;
  static const _claveTema = 'tema';

  Future<ThemeMode> leerTema() async {
    final valor = await _prefs.getString(_claveTema);
    return ThemeMode.values.firstWhere(
      (m) => m.name == valor,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> guardarTema(ThemeMode modo) => _prefs.setString(_claveTema, modo.name);
}