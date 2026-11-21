---
name: nuevo-endpoint
description: Crea un endpoint REST nuevo en sale-api siguiendo la arquitectura del proyecto (ruta, controlador, Form Request, Service, test Pest). Usalo cuando el usuario pida agregar un endpoint, recurso o ruta a la API.
---

# Crear un endpoint nuevo

Seguí estos pasos en orden. Ajustá nombres al recurso pedido.

## 1. Entender el pedido
- Método HTTP, URL, si requiere autenticación JWT, datos de entrada y respuesta esperada.
- Revisá si ya existe un modelo, servicio o controlador que lo cubra (`app/Models`, `app/Business/Services`, `app/Http/Controllers`).

## 2. Esquema (si hace falta)
```bash
php artisan make:migration create_<tabla>_table
php artisan make:model <Modelo> --factory
```
Definí `$fillable` en el modelo y las relaciones.

## 3. Validación
```bash
php artisan make:request <Accion><Recurso>Request
```
Hacé que extienda `App\Http\Requests\ApiFormRequest` (no `FormRequest`) para que los errores salgan en JSON. Mirá `SaleRequest.php` como ejemplo.

## 4. Lógica de negocio
Creá o extendé un servicio en `app/Business/Services/<Recurso>Service.php`. El controlador no contiene lógica: recibe el request, llama al servicio y devuelve la respuesta. Si escribe en varias tablas, usá `DB::transaction`.

## 5. Controlador
```bash
php artisan make:controller <Recurso>Controller
```
Inyectá el servicio por constructor (ver `SaleController`). Devolvé `response()->json($data, Response::HTTP_*)`.

## 6. Ruta
Agregala en `routes/api.php`. Si escribe datos o expone información de usuarios, va dentro de `Route::middleware('jwt.auth')->group(...)`.

## 7. Tests
Creá `tests/Feature/<Recurso>ControllerTest.php` con Pest (ver `ProductControllerTest.php`): camino feliz, validación 422, sin token 401 si aplica, y 404.

## 8. Verificar
```bash
php artisan route:list --path=api
CACHE_STORE=array DB_CONNECTION=sqlite DB_DATABASE=:memory: vendor/bin/pest tests/Feature/<Recurso>ControllerTest.php
vendor/bin/pint --dirty
```
Reportá al usuario la ruta creada, los archivos tocados y el resultado de los tests.
