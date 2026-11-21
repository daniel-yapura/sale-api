---
name: nueva-migracion
description: Crea una migración de base de datos segura en sale-api (tablas, columnas, índices, claves foráneas) junto con el modelo y factory afectados. Usalo cuando el usuario pida cambiar el esquema de la base.
---

# Cambiar el esquema de la base

## Reglas
- **Nunca** edites una migración que ya está en git: creá una nueva (un hook lo bloquea igual).
- Cada migración tiene un `down()` que revierte exactamente el `up()`.
- Claves foráneas con `foreignId(...)->constrained()` y una política `onDelete` explícita.
- Montos de dinero en `decimal(10, 2)`, no `float`.
- Columnas nuevas en tablas con datos: `nullable()` o `default(...)`.

## Pasos
1. Mirá las migraciones existentes en `database/migrations` para ver el estado actual de la tabla.
2. Generá la migración:
   ```bash
   php artisan make:migration add_<columna>_to_<tabla>_table
   # o
   php artisan make:migration create_<tabla>_table
   ```
3. Actualizá el modelo en `app/Models` (`$fillable`, `$casts`, relaciones).
4. Actualizá la factory en `database/factories` y el seeder si corresponde.
5. Verificá que sube y baja sin errores contra SQLite en memoria:
   ```bash
   CACHE_STORE=array DB_CONNECTION=sqlite DB_DATABASE=:memory: php artisan test
   ```
6. **No corras `php artisan migrate` contra la base del usuario sin preguntar.** Mostrale el SQL con
   `php artisan migrate --pretend` y dejá que decida.
