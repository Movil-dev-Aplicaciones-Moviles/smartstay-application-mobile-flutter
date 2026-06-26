# SmartStay Flutter - Kotlin UI 1:1 Port

Versión Flutter conectada al backend y ajustada para copiar el flujo visual principal de la app Android/Kotlin.

## Flujo copiado del Kotlin

- Login centrado con título SmartStay.
- Registro con usuario, contraseña y confirmación.
- Si el rol puede gestionar usuarios, entra a Usuarios.
- Si el rol no gestiona usuarios, entra a Perfil.
- Usuarios con AppBar, botones de perfil, fichas, refrescar y cerrar sesión.
- FAB para crear usuario según permiso.
- Cards de usuario tipo ElevatedCard.
- Detalle de usuario con avatar circular, rol, estado, sucursal y sede.
- Botones de editar, asignar rol, activar/desactivar.
- Diálogo de confirmación para desactivar usuario.
- Diálogo de asignación de roles filtrado por jerarquía.
- Crear/editar usuario, cambiar contraseña, perfiles y hoteles.

## Backend

API por defecto:

```text
https://application-mobile-backend.onrender.com/api/v1
```

## Correr local

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run -d chrome --web-browser-flag="--disable-web-security" --web-browser-flag="--user-data-dir=C:\temp\flutter_chrome"
```
