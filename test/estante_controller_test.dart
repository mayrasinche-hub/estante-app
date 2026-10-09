import 'package:estante/data/models/libro.dart';
import 'package:estante/modules/estante/estante_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  late RepoLibrosFalso repo;
  late RegistroSellosFalso sellos;

  setUp(() {
    repo = RepoLibrosFalso([
      libroDePrueba(1, EstadoLibro.porLeer),
      libroDePrueba(2, EstadoLibro.leyendo),
      libroDePrueba(3, EstadoLibro.leido),
    ]);
    sellos = RegistroSellosFalso();
  });

  Future<EstanteController> controladorListo([UbicacionFalsa? ubicacion]) async {
    final c = EstanteController(repo, sellos, ubicacion);
    await c.cargar();
    return c;
  }

  test('agrupa los libros en su repisa según el estado', () async {
    final c = await controladorListo();
    expect(c.estado.value, Carga.exito);
    expect(c.de(EstadoLibro.porLeer).map((l) => l.id), [1]);
    expect(c.de(EstadoLibro.leyendo).map((l) => l.id), [2]);
    expect(c.de(EstadoLibro.leido).map((l) => l.id), [3]);
  });

  test('un libro nuevo siempre llega a la repisa En espera', () async {
    final c = await controladorListo();
    final error = await c.agregar('  Rayuela ', ' Cortázar ');
    expect(error, isNull);
    final nuevo = c.libros.last;
    expect(nuevo.titulo, 'Rayuela');
    expect(nuevo.estado, EstadoLibro.porLeer);
  });

  test('el marcapáginas avanza un solo paso: por leer → leyendo', () async {
    final c = await controladorListo();
    await c.avanzar(c.porId(1)!);
    expect(c.porId(1)!.estado, EstadoLibro.leyendo);
    expect(sellos.datos, isEmpty);
  });

  test('al llegar a leído se guarda el sello con la fecha', () async {
    final c = await controladorListo();
    await c.avanzar(c.porId(2)!);
    expect(c.porId(2)!.estado, EstadoLibro.leido);
    expect(sellos.datos[2], isNotNull);
    expect(c.ultimoSellado.value, 2);
  });

  test('un libro leído no puede avanzar más', () async {
    final c = await controladorListo();
    final error = await c.avanzar(c.porId(3)!);
    expect(error, 'Este libro ya está leído.');
    expect(c.porId(3)!.estado, EstadoLibro.leido);
  });

  test('el sello guarda el lugar cuando hay ubicación', () async {
    final c = await controladorListo(UbicacionFalsa((-3.99, -79.20)));
    await c.avanzar(c.porId(2)!);
    await Future<void>.delayed(Duration.zero);
    expect(sellos.datos[2]!.tieneLugar, isTrue);
    expect(sellos.datos[2]!.lat, -3.99);
  });

  test('sin permiso de ubicación el libro se marca leído igual', () async {
    final c = await controladorListo(UbicacionFalsa(null));
    await c.avanzar(c.porId(2)!);
    await Future<void>.delayed(Duration.zero);
    expect(c.porId(2)!.estado, EstadoLibro.leido);
    expect(sellos.datos[2]!.tieneLugar, isFalse);
  });

  test('eliminar quita el libro y su sello', () async {
    final c = await controladorListo();
    await c.avanzar(c.porId(2)!);
    await c.eliminar(c.porId(2)!);
    expect(c.porId(2), isNull);
    expect(sellos.datos.containsKey(2), isFalse);
  });

  test('sin conexión y sin caché se muestra el error', () async {
    repo.sinRed = true;
    final c = await controladorListo();
    expect(c.estado.value, Carga.error);
    expect(c.mensajeError.value, 'Sin conexión con el servidor.');
  });
}