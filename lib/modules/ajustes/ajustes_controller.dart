import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/storage/preferencias_storage.dart';

class AjustesController extends GetxController {
  AjustesController(this._prefs, ThemeMode temaInicial, String idiomaInicial)
      : modo = temaInicial.obs,
        idioma = idiomaInicial.obs;

  final PreferenciasStorage _prefs;
  final Rx<ThemeMode> modo;
  final RxString idioma;

  Locale get locale =>
      idioma.value == 'en' ? const Locale('en', 'US') : const Locale('es', 'EC');

  Future<void> cambiarTema(ThemeMode nuevo) async {
    modo.value = nuevo;
    Get.changeThemeMode(nuevo);
    await _prefs.guardarTema(nuevo);
  }

  Future<void> cambiarIdioma(String codigo) async {
    idioma.value = codigo;
    await Get.updateLocale(locale);
    await _prefs.guardarIdioma(codigo);
  }
}
