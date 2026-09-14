# Inventario de Elementos — Widgets Comunes (08_pantallas/widgets_comunes)

**Directorio:** `lib\08_pantallas\widgets_comunes\`
**Archivos:** 1
**Fecha:** 2026-09-05
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Componentes por Rol Funcional

| # | Rol | Componente | Archivo | Líneas | Tipo | Estado |
|---|-----|------------|---------|--------|------|--------|
| 1 | Widget presentación | `letrerprecio()` | `widget_letrero_tipo_transaccion.dart` | 6-50 | Función pura (Stateless) | ✅ Completo |
| 2 | Import | `data_espacios_casas_get.dart` | `widget_letrero_tipo_transaccion.dart` | 1 | Modelo `ValueEspaciosCasaGet` | ✅ Completo |
| 3 | Import | `var_color_themes.dart` | `widget_letrero_tipo_transaccion.dart` | 4 | `appTheme` ColorScheme | ✅ Completo |

---

## Tabla 2 — Detalle por Archivo

### `widget_letrero_tipo_transaccion.dart`

| Atributo | Valor |
|----------|-------|
| **Ruta** | `lib/08_pantallas/widgets_comunes/widget_letrero_tipo_transaccion.dart` |
| **Líneas totales** | 51 |
| **Líneas de lógica** | 6-50 |
| **Dependencias** | `data_espacios_casas_get.dart` (modelo), `var_color_themes.dart` (appTheme) |
| **Clases/Funciones** | `letrerprecio(ValueEspaciosCasaGet listaSeleccionadas)` |
| **Estado** | En código |
| **Generado por build_runner** | No |
| **Freezed** | No |
| **Comentarios/deuda** | Case default `Text("")` sin fallback visible |

---

## Trazabilidad

| ID Documento | Punto de referencia |
|--------------|---------------------|
| `02_Epics_EARS/08_pantallas_widgets_comunes.md` | REQ-WC-001 a REQ-WC-007 |
| `03_Features_BDD/08_pantallas_widgets_comunes/letrerprecio_tipo_transaccion.feature` | 5 escenarios |
| `04_User_Stories/08_pantallas_widgets_comunes.md` | US-WC-001 a US-WC-005 |

---

## Notas

- **Widget singleton**: Se importa en `widget_wrap_modern_card.dart` (`08_pantallas/inicio/`) para mostrar el precio en cada card del catálogo.
- **Sin estado propio**: La función es pura — no `StatefulWidget` ni `setState`.
- **Caso default vacío**: Si `tipodetransaccion` no es Venta, Renta, Venta/Renta ni Traspaso, se retorna `Text("")` sin placeholder visible. Esto es una deuda de UX menor.
- **Sin formato de miles**: El precio se muestra como número crudo (e.g., `1500000` no `1,500,000`). Formato de miles es responsabilidad del modelo o del caller.
