---
name: correr-tests
description: Corre la suite Pest de sale-api con SQLite en memoria, interpreta los fallos y propone correcciones. Usalo cuando el usuario pida correr tests, verificar que todo funcione o arreglar tests rotos.
---

# Correr los tests

## 1. Preparar
- Si no existe `vendor/`, corré `composer install`.
- Si no existe `.env.testing`, no lo leas ni lo crees con secretos: los tests corren con variables de entorno en la línea de comando.

## 2. Ejecutar
Suite completa:
```bash
DB_CONNECTION=sqlite DB_DATABASE=:memory: php artisan test
```
Un archivo o un test:
```bash
DB_CONNECTION=sqlite DB_DATABASE=:memory: vendor/bin/pest tests/Unit/SaleEntityTest.php
DB_CONNECTION=sqlite DB_DATABASE=:memory: vendor/bin/pest --filter="Crear producto"
```
Si falla por `APP_KEY`, `JWT_SECRET` o `KEY_ENCRYPT` faltantes, agregalos inline con valores de prueba, por ejemplo:
`APP_KEY=base64:$(php -r 'echo base64_encode(random_bytes(32));') JWT_SECRET=test-secret KEY_ENCRYPT=test`.

## 3. Interpretar fallos
Para cada test que falla:
1. Leé el test y el código que prueba.
2. Decidí si el error está en el test (expectativa vieja, dato de factory) o en el código (bug).
3. Si es un bug del código, explicalo con `archivo:línea` antes de corregirlo.

## 4. Reportar
Total de tests, cuántos pasan, cuáles fallan y por qué. No marques nada como resuelto sin volver a correrlo.
