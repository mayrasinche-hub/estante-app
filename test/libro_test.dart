import 'package:estante/data/models/libro.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('el estado solo avanza un paso: por leer → leyendo → leído', () {
    expect(EstadoLibro.porLeer.siguiente, EstadoLibro.leyendo);
    expect(EstadoLibro.leyendo.siguiente, EstadoLibro.leido);
    expect(EstadoLibro.leido.siguiente, isNull);
  });

  test('los estados coinciden con los textos del backend', () {
    expect(EstadoLibro.desdeApi('por leer'), EstadoLibro.porLeer);
    expect(EstadoLibro.desdeApi('leyendo'), EstadoLibro.leyendo);
    expect(EstadoLibro.desdeApi('leído'), EstadoLibro.leido);
  });

  test('un libro se convierte a JSON y vuelve igual', () {
    const original = Libro(id: 7, titulo: 'Camino', autor: 'Escrivá', estado: EstadoLibro.leyendo);
    final copia = Libro.desdeJson(original.aJson());
    expect(copia.id, 7);
    expect(copia.titulo, 'Camino');
    expect(copia.estado, EstadoLibro.leyendo);
  });
}