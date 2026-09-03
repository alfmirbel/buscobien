# Especificación SDD: Modelo de Búsqueda de Propiedades
**Archivo:** `lib/08_pantallas/propiedades/data_find_propiedades.dart`

---

## 1. Requerimientos Ubicuos
- El sistema deberá exponer una clase `FindPropiedades` con una lista de objetos `Doc` y una cadena `bookmark` para paginación.
- El sistema deberá exponer una clase `Doc` con propiedades `id`, `rev` y `espacioscasa`.
- El sistema deberá mapear el campo JSON `_id` a la propiedad `id` del modelo.
- El sistema deberá mapear el campo JSON `_rev` a la propiedad `rev` del modelo.
- El sistema deberá mapear el campo JSON `espacioscasa` a una instancia de `EspaciosCasa`.
- El sistema deberá serializar objetos `FindPropiedades` a JSON mediante el método `toJson`.
- El sistema deberá deserializar cadenas JSON a `FindPropiedades` mediante el factory `fromJson`.

## 2. Requerimientos Controlados por Eventos
- Cuando el backend retorne un JSON de búsqueda de propiedades, el sistema deberá parsear la lista de `docs` y construir objetos `Doc` para cada entrada.
- Cuando se invoque `findPropiedadesFromJson`, el sistema deberá decodificar la cadena JSON y transformarla en un objeto `FindPropiedades`.
- Cuando se invoque `findPropiedadesToJson`, el sistema deberá codificar el objeto `FindPropiedades` incluyendo la lista de documentos y el bookmark.

## 3. Requerimientos Controlados por Estados
- Mientras el sistema se encuentre en el estado de navegación de resultados de búsqueda, el modelo `FindPropiedades` deberá estar disponible para ser consumido por la capa de presentación.
- Mientras se construye un objeto `Doc` desde JSON, el sistema deberá transformar la clave `espacioscasa` en una instancia de `EspaciosCasa`.

## 4. Requerimientos de Comportamiento No Deseado
- Si el JSON de entrada no contiene la clave `docs`, entonces el sistema deberá lanzar un error de parseo durante la deserialización.
- Si el JSON de entrada no contiene la clave `bookmark`, entonces el sistema deberá lanzar un error de parseo durante la deserialización.
- Si el JSON de un documento no contiene `_id` o `_rev`, entonces el sistema deberá fallar al construir el objeto `Doc`.
- Si el campo `espacioscasa` en el JSON está malformado, entonces el sistema deberá propagar la excepción de `EspaciosCasa.fromJson`.

## 5. Requerimientos de Funciones Opcionales
- Donde se requiera depuración, el sistema deberá exponer la estructura de datos serializada para inspección de red.

## 6. Requerimientos Complejos
- Mientras el sistema procesa la respuesta paginada de propiedades, cuando se detecte un `bookmark` no vacío, el sistema deberá conservarlo para habilitar la carga del siguiente lote de resultados.
