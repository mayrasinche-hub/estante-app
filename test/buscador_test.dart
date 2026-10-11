import 'package:estante/data/models/libro.dart';
import 'package:estante/modules/estante/estante_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  late EstanteController c;

  setUp(() async {
    final repo = RepoLibrosFalso([
      const Libro(id: 1, titulo: 'Las moradas', autor: 'Santa Teresa de Jesús', estado: EstadoLibro.porLeer),
      const Libro(id: 2, titulo: 'Confesiones', autor: 'San Agustín', estado: EstadoLibro.leyendo),
      const Libro(id: 3, titulo: 'Camino', autor: 'Josemaría Escrivá', estado: EstadoLibro.leido),
    ]);
    c = EstanteController(repo, RegistroSellosFalso());
    await c.cargar();
  });

  test('sin búsqueda se ven todos los libros', () {
    expect(c.hayResultados, isTrue);
    expect(c.de(EstadoLibro.porLeer).length, 1);
    expect(c.de(EstadoLibro.leyendo).length, 1);
    expect(c.de(EstadoLibro.leido).length, 1);
  });

  test('encuentra por título sin importar mayúsculas', () {
    c.busqueda.value = 'CAMINO';
    expect(c.de(EstadoLibro.leido).map((l) => l.id), [3]);
    expect(c.de(EstadoLibro.porLeer), isEmpty);
  });

  test('encuentra por autor aunque se escriba sin tildes', () {
    c.busqueda.value = 'agustin';
    expect(c.de(EstadoLibro.leyendo).map((l) => l.id), [2]);
  });

  test('avisa cuando nada coincide', () {
    c.busqueda.value = 'harry potter';
    expect(c.hayResultados, isFalse);
  });
}
