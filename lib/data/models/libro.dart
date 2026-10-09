enum EstadoLibro {
  porLeer('por leer'),
  leyendo('leyendo'),
  leido('leído');

  const EstadoLibro(this.api);

  final String api;

  static EstadoLibro desdeApi(String valor) => EstadoLibro.values.firstWhere(
        (e) => e.api == valor,
        orElse: () => EstadoLibro.porLeer,
      );

  EstadoLibro? get siguiente => switch (this) {
        EstadoLibro.porLeer => EstadoLibro.leyendo,
        EstadoLibro.leyendo => EstadoLibro.leido,
        EstadoLibro.leido => null,
      };
}

class Libro {
  const Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.estado,
  });

  final int id;
  final String titulo;
  final String autor;
  final EstadoLibro estado;

  factory Libro.desdeJson(Map<String, dynamic> json) => Libro(
        id: json['id'] as int,
        titulo: json['titulo'] as String,
        autor: json['autor'] as String,
        estado: EstadoLibro.desdeApi(json['estado'] as String),
      );

  Map<String, dynamic> aJson() => {
        'id': id,
        'titulo': titulo,
        'autor': autor,
        'estado': estado.api,
      };

  Libro copiarCon({EstadoLibro? estado}) => Libro(
        id: id,
        titulo: titulo,
        autor: autor,
        estado: estado ?? this.estado,
      );
}