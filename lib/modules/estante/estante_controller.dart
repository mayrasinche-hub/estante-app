import 'dart:async';

import 'package:get/get.dart';

import '../../data/api/api_error.dart';
import '../../data/models/libro.dart';
import '../../data/models/sello.dart';
import '../../data/repositories/libros_repositorio.dart';
import '../../data/storage/sellos_storage.dart';
import '../../data/ubicacion/ubicacion.dart';

enum Carga { cargando, exito, error }

class EstanteController extends GetxController {
  EstanteController(this._repo, this._registro, [this._ubicacion]);

  final LibrosRepositorio _repo;
  final RegistroSellos _registro;
  final Ubicacion? _ubicacion;

  final libros = <Libro>[].obs;
  final sellos = <int, Sello>{}.obs;
  final estado = Carga.cargando.obs;
  final mensajeError = ''.obs;
  final sinConexion = false.obs;
  final guardando = false.obs;
  final ultimoSellado = RxnInt();

  @override
  void onInit() {
    super.onInit();
    cargar();
    _cargarSellos();
  }

  List<Libro> de(EstadoLibro e) => libros.where((l) => l.estado == e).toList();

  Libro? porId(int id) => libros.firstWhereOrNull((l) => l.id == id);

  Future<void> _cargarSellos() async => sellos.assignAll(await _registro.todos());

  Future<void> cargar() async {
    if (libros.isEmpty) {
      estado.value = Carga.cargando;
    }
    try {
      libros.assignAll(await _repo.listar());
      sinConexion.value = _repo.sinConexion;
      estado.value = Carga.exito;
    } on ApiError catch (e) {
      mensajeError.value = _texto(e);
      estado.value = Carga.error;
    }
  }

  Future<String?> agregar(String titulo, String autor) async {
    guardando.value = true;
    try {
      libros.add(await _repo.agregar(titulo.trim(), autor.trim()));
      sinConexion.value = false;
      return null;
    } on ApiError catch (e) {
      return _texto(e);
    } finally {
      guardando.value = false;
    }
  }

  Future<String?> avanzar(Libro libro) async {
    guardando.value = true;
    try {
      final actualizado = await _repo.avanzar(libro);
      final i = libros.indexWhere((l) => l.id == libro.id);
      if (i >= 0) {
        libros[i] = actualizado;
      }
      if (actualizado.estado == EstadoLibro.leido) {
        final sello = Sello(fecha: DateTime.now());
        sellos[libro.id] = sello;
        ultimoSellado.value = libro.id;
        await _registro.guardar(libro.id, sello);
        unawaited(_anotarLugar(libro.id, sello));
      }
      return null;
    } on ApiError catch (e) {
      return _texto(e);
    } finally {
      guardando.value = false;
    }
  }

  Future<String?> eliminar(Libro libro) async {
    guardando.value = true;
    try {
      await _repo.eliminar(libro.id);
      libros.removeWhere((l) => l.id == libro.id);
      sellos.remove(libro.id);
      await _registro.borrar(libro.id);
      return null;
    } on ApiError catch (e) {
      return _texto(e);
    } finally {
      guardando.value = false;
    }
  }

  Future<void> _anotarLugar(int id, Sello sello) async {
    final punto = await _ubicacion?.actual();
    if (punto == null) {
      return;
    }
    final conLugar = Sello(fecha: sello.fecha, lat: punto.$1, lng: punto.$2);
    sellos[id] = conLugar;
    await _registro.guardar(id, conLugar);
  }

  String _texto(ApiError e) =>
      e.sinConexion ? 'Sin conexión con el servidor.' : e.mensaje;
}