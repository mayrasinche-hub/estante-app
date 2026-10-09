import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/sello.dart';

abstract class RegistroSellos {
  Future<Map<int, Sello>> todos();
  Future<void> guardar(int libroId, Sello sello);
  Future<void> borrar(int libroId);
}

class SellosStorage implements RegistroSellos {
  SellosStorage([SharedPreferencesAsync? prefs])
      : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;
  static const _clave = 'sellos';

  @override
  Future<Map<int, Sello>> todos() async {
    final texto = await _prefs.getString(_clave);
    if (texto == null) {
      return {};
    }
    final mapa = jsonDecode(texto) as Map<String, dynamic>;
    return mapa.map(
      (k, v) => MapEntry(int.parse(k), Sello.desdeJson(v as Map<String, dynamic>)),
    );
  }

  @override
  Future<void> guardar(int libroId, Sello sello) async {
    final actuales = await todos();
    actuales[libroId] = sello;
    await _escribir(actuales);
  }

  @override
  Future<void> borrar(int libroId) async {
    final actuales = await todos();
    actuales.remove(libroId);
    await _escribir(actuales);
  }

  Future<void> _escribir(Map<int, Sello> sellos) => _prefs.setString(
        _clave,
        jsonEncode(sellos.map((k, v) => MapEntry('$k', v.aJson()))),
      );
}