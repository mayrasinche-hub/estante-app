import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/storage/preferencias_storage.dart';

class TemaController extends GetxController {
  TemaController(this._prefs, ThemeMode inicial) : modo = inicial.obs;

  final PreferenciasStorage _prefs;
  final Rx<ThemeMode> modo;

  Future<void> cambiar(ThemeMode nuevo) async {
    modo.value = nuevo;
    Get.changeThemeMode(nuevo);
    await _prefs.guardarTema(nuevo);
  }
}