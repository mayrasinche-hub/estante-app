import 'package:estante/data/models/libro.dart';
import 'package:estante/data/repositories/libros_repositorio_cache.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  test('con conexión guarda una copia del estante', () async {
    final api = RepoLibrosFalso([libroDePrueba(1, EstadoLibro.porLeer)]);
    final cache = CacheFalsa();
    final repo = LibrosRepositorioConCache(api, cache);

    await repo.listar();

    expect(cache.guardados.length, 1);
    expect(repo.sinConexion, isFalse);
  });

  test('sin conexión muestra el último estante guardado', () async {
    final api = RepoLibrosFalso([libroDePrueba(1, EstadoLibro.porLeer)]);
    final cache = CacheFalsa();
    final repo = LibrosRepositorioConCache(api, cache);
    await repo.listar();

    api.sinRed = true;
    final libros = await repo.listar();

    expect(libros.length, 1);
    expect(repo.sinConexion, isTrue);
  });
}