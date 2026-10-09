import '../api/api_error.dart';
import '../models/libro.dart';
import '../storage/cache_storage.dart';
import 'libros_repositorio.dart';

class LibrosRepositorioConCache implements LibrosRepositorio {
  LibrosRepositorioConCache(this._api, this._cache);

  final LibrosRepositorio _api;
  final CacheStorage _cache;
  bool _sinConexion = false;

  @override
  bool get sinConexion => _sinConexion;

  @override
  Future<List<Libro>> listar() async {
    try {
      final libros = await _api.listar();
      _sinConexion = false;
      await _cache.guardarLibros(libros);
      return libros;
    } on ApiError catch (e) {
      if (!e.sinConexion) {
        rethrow;
      }
      final guardados = await _cache.leerLibros();
      if (guardados.isEmpty) {
        rethrow;
      }
      _sinConexion = true;
      return guardados;
    }
  }

  @override
  Future<Libro> agregar(String titulo, String autor) => _api.agregar(titulo, autor);

  @override
  Future<Libro> avanzar(Libro libro) => _api.avanzar(libro);

  @override
  Future<void> eliminar(int id) => _api.eliminar(id);
}