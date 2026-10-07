# SDD — Módulo `lib/08_pantallas/widgets_comunes` — Especificación de Arquitectura
## Especificación General del Módulo de Widgets Comunes
**Módulo:** `lib/08_pantallas/widgets_comunes/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `widget_letrero_tipo_transaccion.dart` | Fuente — Widget Función | Renderiza el precio de una propiedad formateado según su tipo de transacción (Venta, Renta, Venta/Renta, Traspaso) |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras el widget esté siendo renderizado.

**SDD-WID-001**
El sistema deberá renderizar `letrerprecio` como función widget pura que recibe un parámetro `ValueEspaciosCasaGet listaSeleccionadas` y devuelve un `Widget`.

**SDD-WID-002**
El sistema deberá mostrar el texto del precio en color `appTheme.onPrimaryContainer`, garantizando contraste y legibilidad según el tema activo.

**SDD-WID-003**
El sistema deberá aplicar `fontSize: 12` y `fontWeight: FontWeight.bold` al texto de precio en todos los casos.

**SDD-WID-004**
El sistema deberá mostrar texto vacío (`Text("")`) cuando el tipo de transacción no coincida con ninguno de los casos del switch o cuando el valor sea nulo/vacío.

**SDD-WID-005**
El sistema deberá incluir la moneda de la propiedad (`listaSeleccionadas.espacioscasa.moneda`) al final del texto de precio en todos los formatos.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-WID-010**
Cuando `listaSeleccionadas.espacioscasa.tipodetransaccion` sea `"Venta"`, el sistema deberá mostrar el texto `"Venta: {precioventa} {moneda}"`.

**SDD-WID-011**
Cuando `listaSeleccionadas.espacioscasa.tipodetransaccion` sea `"Renta"`, el sistema deberá mostrar el texto `"Renta: {preciorenta} {moneda}"`.

**SDD-WID-012**
Cuando `listaSeleccionadas.espacioscasa.tipodetransaccion` sea `"Venta/Renta"`, el sistema deberá mostrar el texto `"Venta/Renta: {preciorenta}/{precioventa} {moneda}"`.

**SDD-WID-013**
Cuando `listaSeleccionadas.espacioscasa.tipodetransaccion` sea `"Traspaso"`, el sistema deberá mostrar el texto `"Traspaso: {precioventa} {moneda}"`.

**SDD-WID-014**
Cuando el widget se renderice en cualquier pantalla, el sistema deberá devolver el `Text` correspondiente sin efectos secundarios ni mutaciones de estado.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-WID-020**
Mientras `tipodetransaccion == "Venta"`, el sistema deberá mostrar el precio de venta (`precioventa`) como valor numérico.

**SDD-WID-021**
Mientras `tipodetransaccion == "Renta"`, el sistema deberá mostrar el precio de renta (`preciorenta`) como valor numérico.

**SDD-WID-022**
Mientras `tipodetransaccion == "Venta/Renta"`, el sistema deberá mostrar ambos precios: renta primero, luego venta, separados por `/`.

**SDD-WID-023**
Mientras `tipodetransaccion == "Traspaso"`, el sistema deberá mostrar el precio de venta (`precioventa`) y no el de renta.

**SDD-WID-024**
Mientras `tipodetransaccion` sea cualquier otro valor no contemplado en el switch, el sistema deberá mantener `letreroprecio` como `Text("")` vacío.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-WID-030**
Si `listaSeleccionadas.espacioscasa.tipodetransaccion` es `null` o vacío, entonces el sistema deberá mostrar `Text("")` y no lanzar excepciones.

**SDD-WID-031**
Si `listaSeleccionadas.espacioscasa.precioventa` o `preciorenta` son `null`, entonces el sistema deberá mostrar el texto con la cadena `"null"` o vacía sin crashear.

**SDD-WID-032**
Si `listaSeleccionadas.espacioscasa.moneda` es `null` o vacío, entonces el sistema deberá mostrar el texto sin moneda o con espacio vacío al final.

**SDD-WID-033**
Si el tipo de transacción tiene mayúsculas/minúsculas diferentes a los casos del switch (ej. `"venta"` en lugar de `"Venta"`), entonces el sistema deberá mostrar texto vacío en lugar de coincidir parcialmente.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-WID-040**
Donde el widget `letrerprecio` se utilice en `PaginaDetalleWidget` o `WrapModernCardPropiedades`, el sistema deberá heredar el color de `appTheme.onPrimaryContainer` para mantener consistencia con el tema M3.

**SDD-WID-041**
Donde se requiera mostrar el precio en tarjetas de búsqueda, el sistema podrá reutilizar `letrerprecio` sin modificar su implementación interna.

**SDD-WID-042**
Donde la propiedad tenga `tipodetransaccion = "Venta/Renta"`, el sistema deberá mostrar el formato compuesto `renta/venta` para diferenciarlo de los formatos simples.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-WID-050**
Mientras el usuario vea una propiedad en `PaginaDetalleWidget`, cuando se renderice la sección de precios, el sistema deberá llamar a `letrerprecio(propiedad)` y mostrar el texto formateado con el color, tamaño y peso definidos por el tema.

**SDD-WID-051**
Mientras el usuario vea una propiedad en `WrapModernCardPropiedades`, cuando la tarjeta necesite mostrar el precio, el sistema deberá invocar `letrerprecio` y mostrar el resultado en el layout de la tarjeta sin alterar el resto de los elementos visuales.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    letrerprecio()                               │
│                                                                 │
│  Entrada: ValueEspaciosCasaGet                                  │
│           └── espacioscasa.tipodetransaccion                     │
│           └── espacioscasa.precioventa                           │
│           └── espacioscasa.preciorenta                           │
│           └── espacioscasa.moneda                                │
│                                                                 │
│  Proceso: switch (tipodetransaccion)                            │
│                                                                 │
│  Salida: Widget Text                                           │
│          └── "Venta: {precioventa} {moneda}"                   │
│          └── "Renta: {preciorenta} {moneda}"                   │
│          └── "Venta/Renta: {preciorenta}/{precioventa} {moneda}"│
│          └── "Traspaso: {precioventa} {moneda}"                │
│          └── Text("") en caso default                           │
│                                                                 │
│  Estilo: fontSize 12, bold, appTheme.onPrimaryContainer        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

| Elemento | Tipo | Comportamiento |
|---|---|---|
| `letrerprecio` | Función widget | Recibe `ValueEspaciosCasaGet` y devuelve `Text` con precio formateado |
| `tipodetransaccion` | Campo de entrada | Determina el formato de salida mediante `switch` |
| `precioventa` | Campo de entrada | Usado en formatos Venta, Venta/Renta y Traspaso |
| `preciorenta` | Campo de entrada | Usado en formatos Renta y Venta/Renta |
| `moneda` | Campo de entrada | Anexado al final del texto en todos los formatos |
| `Text` salida | Widget | `fontSize: 12`, `fontWeight: bold`, `color: appTheme.onPrimaryContainer` |
| `default` | Caso switch | Retorna `Text("")` vacío |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | Función widget pura en lugar de clase con estado | No requiere gestión de estado; la lógica es determinista basada en el parámetro de entrada |
| DD-02 | Uso de `switch` para tipos de transacción | Proporciona legibilidad clara y garantiza exhaustividad de casos |
| DD-03 | `appTheme.onPrimaryContainer` como color de texto | Asegura contraste automático según el esquema de colores activo |
| DD-04 | `fontSize: 12` y `bold` | Tamaño compacto legible, consistente con tarjetas de propiedades |
| DD-05 | Formato `Venta/Renta` como `renta/venta` | Convención de la app para mostrar el precio de renta primero |
| DD-06 | Retorno de `Text("")` en caso default | Evita mostrar valores incorrectos si el tipo de transacción es desconocido |
| DD-07 | Inclusión de `moneda` en todos los formatos | Garantiza consistencia informativa independientemente del tipo de transacción |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
