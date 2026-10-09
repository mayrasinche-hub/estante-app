import 'package:get/get.dart';

import '../../data/api/api_error.dart';
import '../../data/models/libro.dart';
import '../../data/repositories/libros_repositorio.dart';

enum Carga { cargando, exito, error }

class EstanteController extends GetxController {
  EstanteController(this._repo);

  final LibrosRepositorio _repo;

  final libros = <Libro>[].obs;
  final estado = Carga.cargando.obs;
  final mensajeError = ''.obs;
  final sinConexion = false.obs;

  @override
  void onInit() {
    super.onInit();
    cargar();
  }

  List<Libro> de(EstadoLibro e) => libros.where((l) => l.estado == e).toList();

  Future<void> cargar() async {
    if (libros.isEmpty) {
      estado.value = Carga.cargando;
    }
    try {
      libros.assignAll(await _repo.listar());
      sinConexion.value = _repo.sinConexion;
      estado.value = Carga.exito;
    } on ApiError catch (e) {
      mensajeError.value = e.sinConexion
          ? 'No pudimos conectar con el servidor.'
          : e.mensaje;
      estado.value = Carga.error;
    }
  }
}