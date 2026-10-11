# Estante

Tu biblioteca, a tu ritmo.

App móvil en Flutter para el Proyecto Integrador. Es el frontend del backend
**Biblioteca Personal** (FastAPI + OAuth2/JWT): cada usuario guarda sus libros
y los mueve de *por leer* a *leyendo* y a *leído*, sin saltar pasos.

## La idea

La biblioteca se ve como un estante real: cada libro es un lomo de color
sobre una repisa de madera. El color sale del título, así que el mismo libro
siempre se ve igual.

La regla de negocio del backend se convirtió en la interacción principal.
En cada libro hay un marcapáginas que solo se puede arrastrar hacia adelante,
así que desde la interfaz no hay forma de saltarse un estado. Cuando un libro
llega a *leído*, cae un sello con la fecha y el lugar donde lo terminaste.

## Qué hace

- Registro e inicio de sesión contra el backend. El token se guarda cifrado
  con `flutter_secure_storage`, y si expira la app vuelve sola al login.
- Estante con tres repisas: En espera, Abiertos y Terminados.
- Agregar libro con vista previa del lomo mientras se escribe el título.
- Detalle del libro con su recorrido de estados, marcapáginas y opción de
  quitarlo del estante (con confirmación).
- Sello "Leído" con la fecha, guardado en el teléfono.
- Mapa de lecturas (OpenStreetMap): un pin por cada libro terminado, en el
  lugar donde se selló. Si no hay permiso de ubicación, el libro se marca
  leído igual, solo que sin pin.
- Modo sin conexión: si el servidor no responde, se muestra el último
  estante guardado con un aviso.
- Tema claro, oscuro o del sistema, guardado entre sesiones.
- Buscador por título o autor, sin importar tildes ni mayúsculas.
- Disponible en español e inglés.
- Ícono propio de la app.

## Decisiones de diseño

- **Paleta:** papel `#F4EFE6`, tinta `#1F2A2E`, terracota `#A8432F`,
  musgo `#4F6A48` y ocre `#E0A458`. La terracota y el musgo se oscurecieron
  para que el texto claro encima cumpla el contraste mínimo de 4.5:1. El color
  del texto de cada lomo se elige calculando cuál contrasta mejor.
- **Tipografía:** Fraunces para títulos y Work Sans para el texto.
- **Accesibilidad:** etiquetas `Semantics` en lomos, contadores, marcapáginas
  y sello; el marcapáginas también se activa con un toque desde el lector de
  pantalla; botones de al menos 48 dp; los errores se anuncian al aparecer.
- **Cada pantalla tiene sus estados:** cargando (esqueleto del estante),
  vacío, error con reintento y éxito.

## Arquitectura

    lib/
      core/      tema, tokens de diseño y widgets propios (lomo, marcapáginas, sello)
      data/      cliente dio, modelos, repositorios y almacenamiento local
      modules/   una carpeta por pantalla: auth, estante, detalle, mapa, ajustes
      routes/    nombres de rutas

Igual que en el backend, los controladores reciben sus dependencias por
constructor (repositorio de libros, registro de sellos, ubicación). Eso
permite probarlos con implementaciones falsas, sin paquetes de mocks.

| Dónde se guarda | Qué | Paquete |
|---|---|---|
| Almacenamiento cifrado | Token JWT | flutter_secure_storage |
| Preferencias locales | Último estante, sellos y tema | shared_preferences |
| Backend | Usuarios y libros | dio |

## Cómo ejecutarlo

1. Levantar el backend `biblioteca-personal`:

        uv run uvicorn app.main:app --reload

2. Encender un emulador de Android y ejecutar:

        flutter pub get
        flutter run

La app apunta a `http://10.0.2.2:8000`, que desde el emulador equivale al
`localhost` de la computadora. Para otra dirección:

    flutter run --dart-define=API_URL=http://192.168.1.10:8000

Para probar el mapa en el emulador, se puede fijar la ubicación en Loja:

    adb emu geo fix -79.2042 -3.9931

## Tests

    flutter test

21 tests sobre el modelo, el controlador del estante, el buscador, la caché y la pantalla de acceso:

- el estado solo avanza un paso y nunca retrocede;
- un libro nuevo siempre llega a *En espera*;
- un libro leído no puede avanzar más;
- al llegar a *leído* se guarda el sello, con lugar si hay ubicación y sin
  él si no hay permiso;
- eliminar un libro también borra su sello;
- sin conexión se usa el último estante guardado.

## Autora

Mayra Sinche — Proyecto Integrador