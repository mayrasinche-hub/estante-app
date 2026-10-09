import '../api/api_cliente.dart';
import '../api/api_error.dart';
import '../models/libro.dart';

abstract class LibrosRepositorio {
  Future<List<Libro>> listar();
  Future<Libro> agregar(String titulo, String autor);
  Future<Libro> avanzar(Libro libro);
  Future<void> eliminar(int id);
  bool get sinConexion;
}

class LibrosRepositorioApi implements LibrosRepositorio {
  LibrosRepositorioApi(this._cliente);

  final ApiCliente _cliente;

  @override
  bool get sinConexion => false;

  @override
  Future<List<Libro>> listar() async {
    try {
      final respuesta = await _cliente.dio.get(
        '/libros/',
        queryParameters: {'skip': 0, 'limit': 100},
      );
      return (respuesta.data as List)
          .map((e) => Libro.desdeJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ApiError.desde(e);
    }
  }

  @override
  Future<Libro> agregar(String titulo, String autor) async {
    try {
      final respuesta = await _cliente.dio.post(
        '/libros/',
        data: {'titulo': titulo, 'autor': autor},
      );
      return Libro.desdeJson(respuesta.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiError.desde(e);
    }
  }

  @override
  Future<Libro> avanzar(Libro libro) async {
    final siguiente = libro.estado.siguiente;
    if (siguiente == null) {
      throw ApiError('Este libro ya está leído.', codigo: 400);
    }
    try {
      final respuesta = await _cliente.dio.patch(
        '/libros/${libro.id}/estado',
        data: {'estado': siguiente.api},
      );
      return Libro.desdeJson(respuesta.data as Map<String, dynamic>);
    } catch (e) {
      throw ApiError.desde(e);
    }
  }

  @override
  Future<void> eliminar(int id) async {
    try {
      await _cliente.dio.delete('/libros/$id');
    } catch (e) {
      throw ApiError.desde(e);
    }
  }
}