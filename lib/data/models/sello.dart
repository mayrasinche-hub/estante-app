class Sello {
  const Sello({required this.fecha, this.lat, this.lng});

  final DateTime fecha;
  final double? lat;
  final double? lng;

  bool get tieneLugar => lat != null && lng != null;

  factory Sello.desdeJson(Map<String, dynamic> json) => Sello(
        fecha: DateTime.parse(json['fecha'] as String),
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
      );

  Map<String, dynamic> aJson() => {
        'fecha': fecha.toIso8601String(),
        'lat': lat,
        'lng': lng,
      };
}