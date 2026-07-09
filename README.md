# SmartStay Flutter - Cliente

Aplicación Flutter enfocada en cliente/huésped.

## Flujo principal

- La app permite explorar hoteles y habitaciones sin iniciar sesión.
- Si el backend permite lectura pública, Flutter consume `/hotels` y `/rooms` directamente sin token.
- Si el backend todavía protege esos endpoints, Flutter muestra datos de vista previa para que la app no quede bloqueada.
- Para reservar, pagar, ver mis reservas, perfil y seguridad, se solicita iniciar sesión.

## Backend

URL por defecto:

```text
https://application-mobile-backend.onrender.com/api/v1
```

Cuando se actualice el backend, se recomienda dejar públicos:

```text
GET /api/v1/hotels
GET /api/v1/rooms
```

Y mantener protegidos:

```text
POST /api/v1/bookings
GET /api/v1/bookings/me
POST /api/v1/payments
POST /api/v1/users/change-password
POST /api/v1/profiles
```

## Ejecutar

```powershell
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```
