import 'package:geolocator/geolocator.dart';

abstract class Ubicacion {
  Future<(double, double)?> actual();
}

class UbicacionGps implements Ubicacion {
  @override
  Future<(double, double)?> actual() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return null;
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
        return null;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
          timeLimit: const Duration(seconds: 10),
        ),
      );
      return (p.latitude, p.longitude);
    } catch (_) {
      return null;
    }
  }
}