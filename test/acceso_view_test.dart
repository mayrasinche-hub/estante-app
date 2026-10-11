import 'package:estante/data/api/api_error.dart';
import 'package:estante/data/repositories/auth_repositorio.dart';
import 'package:estante/modules/auth/acceso_view.dart';
import 'package:estante/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

class AuthFalso implements AuthRepositorio {
  @override
  Future<void> registrar(String email, String password) async {}

  @override
  Future<void> iniciarSesion(String email, String password) async =>
      throw ApiError('No autorizado', codigo: 401);

  @override
  Future<bool> haySesion() async => false;

  @override
  Future<void> cerrarSesion() async {}
}

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    Get.testMode = true;
    Get.put(AuthController(AuthFalso(), CacheFalsa()));
  });

  tearDown(Get.reset);

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const GetMaterialApp(home: AccesoView()));
    await tester.pump();
  }

  testWidgets('pide correo y contraseña antes de entrar', (tester) async {
    await abrir(tester);
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Escribe tu correo'), findsOneWidget);
    expect(find.text('Escribe tu contraseña'), findsOneWidget);
  });

  testWidgets('avisa cuando el correo o la contraseña no coinciden', (tester) async {
    await abrir(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'mayra@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'equivocada');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Correo o contraseña incorrectos.'), findsOneWidget);
  });

  testWidgets('cambia al modo de crear cuenta', (tester) async {
    await abrir(tester);
    await tester.tap(find.text('Soy nuevo, crear cuenta'));
    await tester.pump();

    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.text('Ya tengo cuenta'), findsOneWidget);
  });
}
