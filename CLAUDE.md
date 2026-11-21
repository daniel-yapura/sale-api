# sale-api

API REST de ventas en **Laravel 11** (PHP ^8.2) con autenticación **JWT** (`tymon/jwt-auth`) y tests en **Pest 3**.

## Comandos

| Tarea | Comando |
|---|---|
| Instalar dependencias | `composer install` |
| Servidor local | `php artisan serve` |
| Todos los tests | `php artisan test` (o `vendor/bin/pest`) |
| Un test | `vendor/bin/pest --filter="nombre del test"` |
| Formatear | `vendor/bin/pint` (solo cambiados: `vendor/bin/pint --dirty`) |
| Migrar | `php artisan migrate` |
| Ver rutas | `php artisan route:list --path=api` |

## Arquitectura

- `routes/api.php`: todas las rutas (prefijo `/api`). Las protegidas usan el middleware `jwt.auth`.
- `app/Http/Controllers`: controladores finos. Validan con un Form Request y delegan.
- `app/Http/Requests`: validación. `ApiFormRequest` es la base que devuelve errores en JSON.
- `app/Business/Services`: lógica de negocio (por ejemplo `CreateSaleService`, `ProductService`, `EncryptorService`).
- `app/Business/Entities`: entidades de dominio sin Eloquent (`SaleEntity`, `ConceptEntity`, `Taxes`).
- `app/Business/Interfaces`: contratos que se enlazan en `app/Providers`.
- `app/ExternalService`: cliente de una API externa, con sus eventos y listeners.
- `app/Models`: Eloquent (`Product`, `Category`, `Sale`, `Concept`, `User`).
- `tests/Unit` y `tests/Feature`: Pest. Los tests de Feature usan `RefreshDatabase`.

## Convenciones

- La lógica nueva va en un Service dentro de `app/Business/Services`, no en el controlador.
- Toda entrada se valida con un Form Request que extiende `ApiFormRequest`.
- Las respuestas son JSON y usan constantes de `Illuminate\Http\Response` (`Response::HTTP_CREATED`, etc.).
- Cada cambio de comportamiento lleva su test en Pest. Los nombres de los tests están en español, como los existentes.
- Los cambios de esquema van en una migración nueva. Nunca se edita una migración ya publicada.
- Corré `vendor/bin/pint --dirty` antes de commitear (un hook lo hace solo al editar archivos PHP).

## Entorno

- La base por defecto es MariaDB (`.env.example`). Para tests sin base externa usá SQLite en memoria:
  `DB_CONNECTION=sqlite DB_DATABASE=:memory: php artisan test`.
- `.env` y `.env.testing` no se versionan. Hace falta `APP_KEY`, `JWT_SECRET` (`php artisan jwt:secret`) y `KEY_ENCRYPT`.
- Claude no debe leer ni modificar archivos `.env*` salvo `.env.example`.
