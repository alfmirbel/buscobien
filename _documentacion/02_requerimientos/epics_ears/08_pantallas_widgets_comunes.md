# Epic: Widgets Comunes — Etiqueta de Precio por Tipo de Transacción (08_pantallas/widgets_comunes)

**Directorio:** `lib\08_pantallas\widgets_comunes\`  
**Archivos:** `widget_letrero_tipo_transaccion.dart`  
**Fecha:** 2026-09-05  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Comunicación clara de precio/transacción al usuario final | Comprador / Inquilino | Entiende de un vistazo si es Venta, Renta, Venta/Renta o Traspaso | `letrerprecio()` widget reutilizable |
| | Desarrollador | Widget centralizado, no duplicado en cards de inicio | 1 archivo, 38 líneas, sin lógica de negocio |

---

## User Story Mapping

```
Desarrollador usa widget en card
       │
       ▼
┌─────────────────────────────────────────┐
│ Importa letrerprecio(listaSeleccionadas)│
│ Recibe ValueEspaciosCasaGet             │
│ switch(tipodetransaccion) → Text        │
│ con appTheme.onPrimaryContainer         │
└─────────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-WC-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-WC-001 | **Ubicuo** | El sistema mostrará `"Venta: {precioventa} {moneda}"` cuando `tipodetransaccion == "Venta"`. | `widget_letrero_tipo_transaccion.dart:9-17` | En código |
| REQ-WC-002 | **Ubicuo** | El sistema mostrará `"Renta: {preciorenta} {moneda}"` cuando `tipodetransaccion == "Renta"`. | `widget_letrero_tipo_transaccion.dart:19-27` | En código |
| REQ-WC-003 | **Ubicuo** | El sistema mostrará `"Venta/Renta: {preciorenta}/{precioventa} {moneda}"` cuando `tipodetransaccion == "Venta/Renta"`. | `widget_letrero_tipo_transaccion.dart:29-37` | En código |
| REQ-WC-004 | **Ubicuo** | El sistema mostrará `"Traspaso: {precioventa} {moneda}"` cuando `tipodetransaccion == "Traspaso"`. | `widget_letrero_tipo_transaccion.dart:39-48` | En código |
| REQ-WC-005 | **Ubicuo** | El sistema aplicará `fontSize:12, fontWeight:bold, color:appTheme.onPrimaryContainer` a todos los casos. | `widget_letrero_tipo_transaccion.dart:12-16, 22-26, 32-36, 42-46` | En código |
| REQ-WC-006 | **No Deseado** | Si `tipodetransaccion` no coincide con ninguno de los 4 casos, el sistema retornará `Text("")` vacío sin fallback visible. | `widget_letrero_tipo_transaccion.dart:7, 49` | Deuda UX |
| REQ-WC-007 | **Ubicuo** | El widget es **puro** (sin estado, sin lógica de negocio): recibe `ValueEspaciosCasaGet` y retorna `Widget`. | `widget_letrero_tipo_transaccion.dart:6` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `letrerprecio()` — switch tipodetransaccion | `widget_letrero_tipo_transaccion.dart` | 6-50 |
| Caso "Venta" | `widget_letrero_tipo_transaccion.dart` | 9-17 |
| Caso "Renta" | `widget_letrero_tipo_transaccion.dart` | 19-27 |
| Caso "Venta/Renta" | `widget_letrero_tipo_transaccion.dart` | 29-37 |
| Caso "Traspaso" | `widget_letrero_tipo_transaccion.dart` | 39-48 |
| Color `appTheme.onPrimaryContainer` | `var_color_themes.dart` | — |

---

## Notas

- **Ubicación de uso:** `widget_wrap_modern_card.dart` en `08_pantallas/inicio/` (WrapModernCardPropiedades).
- **Deuda:** Caso default vacío `Text("")` — debería mostrar `"N/A"` o placeholder para no dejar hueco visual.
- **Sin Freezed:** El modelo `ValueEspaciosCasaGet` no es Freezed (heredado de data_espacios_casas_get.dart).
