# SmartStay Flutter - v12 Backend Aligned

Versión ajustada al backend `BackendAwSmartstay.API`.

## Alcance real implementado en la app

Esta versión se centra solamente en módulos que existen en el backend:

- IAM / Authentication
- Roles
- Hotels
- Rooms
- Room Types
- Bookings
- Payments
- Profiles
- Analytics
- Admin panel según endpoints reales

## Roles del backend

- `guest`
- `admin`
- `chain_admin`
- `staff`
- `reception`
- `housekeeping`
- `maintenance`

Importante: aunque existen roles operativos como `staff`, `reception`, `housekeeping` y `maintenance`, la mayoría de endpoints del backend actual solo autorizan `guest`, `admin` y `chain_admin`. Por eso la app no inventa un panel operativo completo para esos roles.

## Usuarios demo

- `guest@smartstay.com / 123456` -> guest
- `admin@smartstay.com / 123456` -> admin
- `chain@smartstay.com / 123456` -> chain_admin
- `staff@smartstay.com / 123456` -> staff limitado

## Funcionalidades retiradas o dejadas como evolución futura

Estas funcionalidades no se presentan como implementadas porque el backend no tiene endpoints reales para ellas:

- Control IoT real de luces, temperatura y cortinas.
- Solicitudes reales de room service, limpieza o soporte técnico.
- Notificaciones persistentes.
- Check-in / check-out digital como endpoints propios.
- Tareas reales de housekeeping, recepción y mantenimiento.

## Flujo recomendado para exposición

### Como guest

1. Login con `guest@smartstay.com`.
2. Ver hoteles.
3. Ver habitaciones.
4. Crear reserva.
5. Procesar pago.
6. Revisar perfil.

### Como admin

1. Login con `admin@smartstay.com`.
2. Ver hoteles.
3. Ver habitaciones.
4. Gestionar reservas.
5. Revisar panel admin.
6. Revisar analytics.

### Como chain_admin

1. Login con `chain@smartstay.com`.
2. Ver opciones de administración global.
3. Revisar catálogo global de categorías y amenities.

## Backend base

Backend esperado:

```text
BackendAwSmartstay.API
ASP.NET Core .NET 9
Entity Framework Core
MySQL
JWT
Roles
```

## Comandos

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```
