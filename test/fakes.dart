import 'package:estante/data/api/api_error.dart';
import 'package:estante/data/models/libro.dart';
import 'package:estante/data/models/sello.dart';
import 'package:estante/data/repositories/libros_repositorio.dart';
import 'package:estante/data/storage/cache_storage.dart';
import 'package:estante/data/storage/sellos_storage.dart';
import 'package:estante/data/ubicacion/ubicacion.dart';

Libro libroDePrueba(int id, EstadoLibro estado) =>
    Libro(id: id, titulo: 'Libro $id', autor: 'Autor $id', estado: estado);

class RepoLibrosFalso implements LibrosRepositorio {
  RepoLibrosFalso([List<Libro>? iniciales]) : libros = [...?iniciales];

  final List<Libro> libros;
  bool sinRed = false;
  int _siguienteId = 100;

  void _revisarRed() {
    if (sinRed) {
      throw ApiError('Sin red');
    }
  }

  @override
  bool get sinConexion => false;

  @override
  Future<List<Libro>> listar() async {
    _revisarRed();
    return List.of(libros);
  }

  @override
  Future<Libro> agregar(String titulo, String autor) async {
    _revisarRed();
    final libro = Libro(
      id: _siguienteId++,
      titulo: titulo,
      autor: autor,
      estado: EstadoLibro.porLeer,
    );
    libros.add(libro);
    return libro;
  }

  @override
  Future<Libro> avanzar(Libro libro) async {
    _revisarRed();
    final siguiente = libro.estado.siguiente;
    if (siguiente == null) {
      throw ApiError('Este libro ya está leído.', codigo: 400);
    }
    final actualizado = libro.copiarCon(estado: siguiente);
    libros[libros.indexWhere((l) => l.id == libro.id)] = actualizado;
    return actualizado;
  }

  @override
  Future<void> eliminar(int id) async {
    _revisarRed();
    libros.removeWhere((l) => l.id == id);
  }
}

class CacheFalsa implements CacheStorage {
  List<Libro> guardados = [];

  @override
  Future<void> guardarLibros(List<Libro> libros) async => guardados = List.of(libros);

  @override
  Future<List<Libro>> leerLibros() async => guardados;

  @override
  Future<void> limpiar() async => guardados = [];
}

class RegistroSellosFalso implements RegistroSellos {
  final datos = <int, Sello>{};

  @override
  Future<Map<int, Sello>> todos() async => Map.of(datos);

  @override
  Future<void> guardar(int libroId, Sello sello) async => datos[libroId] = sello;

  @override
  Future<void> borrar(int libroId) async => datos.remove(libroId);
}

class UbicacionFalsa implements Ubicacion {
  UbicacionFalsa(this.punto);

  final (double, double)? punto;

  @override
  Future<(double, double)?> actual() async => punto;
}