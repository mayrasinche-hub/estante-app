import 'package:dio/dio.dart';

class ApiError implements Exception {
  ApiError(this.mensaje, {this.codigo});

  final String mensaje;
  final int? codigo;

  bool get sinConexion => codigo == null;

  factory ApiError.desde(Object error) {
    if (error is ApiError) {
      return error;
    }
    if (error is DioException) {
      final respuesta = error.response;
      if (respuesta == null) {
        return ApiError('No pudimos conectar con el servidor.');
      }
      var mensaje = 'Algo salió mal. Intenta de nuevo.';
      final datos = respuesta.data;
      if (datos is Map && datos['detail'] != null) {
        final detalle = datos['detail'];
        if (detalle is String) {
          mensaje = detalle;
        } else if (detalle is List && detalle.isNotEmpty && detalle.first is Map) {
          mensaje = (detalle.first as Map)['msg']?.toString() ?? mensaje;
        }
      }
      return ApiError(mensaje, codigo: respuesta.statusCode);
    }
    return ApiError('Algo salió mal. Intenta de nuevo.');
  }

  @override
  String toString() => mensaje;
}