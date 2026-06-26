# SmartStay Flutter - Cliente

Aplicación Flutter para clientes/huéspedes de SmartStay, basada en el diseño de la app Android/Kotlin y conectada al backend.

## Módulos del cliente

- Login
- Registro de cliente
- Alojamientos disponibles
- Habitaciones disponibles
- Crear reserva
- Procesar pago
- Perfil del cliente
- Crear perfil
- Cambiar contraseña
- Cerrar sesión

## Backend

URL por defecto:

```text
https://application-mobile-backend.onrender.com/api/v1
```

Para usar otra URL:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5192/api/v1
```

Si Flutter Web falla por CORS durante pruebas locales:

```bash
flutter run -d chrome --web-browser-flag="--disable-web-security" --web-browser-flag="--user-data-dir=C:\temp\flutter_chrome"
```

## Comandos

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run -d chrome --web-browser-flag="--disable-web-security" --web-browser-flag="--user-data-dir=C:\temp\flutter_chrome"
```
