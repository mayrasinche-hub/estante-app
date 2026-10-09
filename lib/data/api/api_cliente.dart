import 'package:dio/dio.dart';

import '../storage/sesion_storage.dart';
import 'api_config.dart';

class ApiCliente {
  ApiCliente(this._sesion, {this.alExpirarSesion}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 6),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _sesion.leerToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final esLogin = error.requestOptions.path.contains('/token');
          if (error.response?.statusCode == 401 && !esLogin) {
            await _sesion.borrarToken();
            alExpirarSesion?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final SesionStorage _sesion;
  final void Function()? alExpirarSesion;
  late final Dio dio;
}