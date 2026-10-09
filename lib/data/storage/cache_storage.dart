import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/libro.dart';

class CacheStorage {
  CacheStorage([SharedPreferencesAsync? prefs])
      : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;
  static const _claveLibros = 'cache_libros';

  Future<void> guardarLibros(List<Libro> libros) => _prefs.setString(
        _claveLibros,
        jsonEncode(libros.map((l) => l.aJson()).toList()),
      );

  Future<List<Libro>> leerLibros() async {
    final texto = await _prefs.getString(_claveLibros);
    if (texto == null) {
      return [];
    }
    return (jsonDecode(texto) as List)
        .map((e) => Libro.desdeJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> limpiar() => _prefs.remove(_claveLibros);
}