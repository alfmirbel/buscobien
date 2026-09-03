# Inventario de Elementos — Pantallas: Detalle de Propiedad + PDF (08_pantallas/propiedades)

**Directorio:** `lib\08_pantallas\propiedades\`
**Total archivos `.dart` fuente:** 3
**Epic asociado:** [`02_Epics_EARS/08_pantallas_propiedades.md`](../../02_Epics_EARS/08_pantallas_propiedades.md)
**Features BDD:** [`03_Features_BDD/08_pantallas_propiedades/detalle_propiedad_pdf.feature`](../../03_Features_BDD/08_pantallas_propiedades/detalle_propiedad_pdf.feature) (9 escenarios)
**User Stories:** [`04_User_Stories/08_pantallas_propiedades.md`](../../04_User_Stories/08_pantallas_propiedades.md) (5 US)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | US-PROP |
|---|-------------|---------|------|----------------|---------|
| 1 | `FindPropiedades`, `Doc` | `data_find_propiedades.dart` | Modelo (json manual) | Respuesta Mango `$in` bulk | US-PROP-001 |
| 2 | `PaginaDetalleWidget`, `PaginaDetalleWidgetState` | `pagina_detalle_propiedad.dart` | ConsumerStatefulWidget | Pantalla detalle completo | todas |
| 3 | `_FotoItemWidget` (sub-widget) | `pagina_detalle_propiedad.dart` (anidado) | StatelessWidget | Miniaturas para saltar a foto del carousel | US-PROP-001 |
| 4 | `_MeGustaButtonFicha` (sub-widget) | `pagina_detalle_propiedad.dart` (anidado) | StatefulWidget | Toggle Me Gusta en ficha | US-PROP-005 |
| 5 | `PdfGeneratorService` | `pagina_detalle_propiedad_pdf.dart` | Servicio | Genera PDF de la ficha con paquete `pdf` | US-PROP-004 |

---

## Tabla 2 — Detalle por archivo

| # | Archivo | Clases / Funciones | Líneas | Dependencias clave | Estado | Comentario / Deuda |
|---|---------|--------------------|--------|---------------------|--------|--------------------|
| 1 | `data_find_propiedades.dart` | `FindPropiedades`, `Doc` | 58 | `dart:convert` | ⚠ deuda | Json manual, no Freezed. 58 líneas, обеспечивает respuesta de Mango `$in` |
| 2 | `pagina_detalle_propiedad.dart` | `PaginaDetalleWidget`, `PaginaDetalleWidgetState`, `_FotoItemWidget`, `_MeGustaButtonFicha` | 588 | `flutter`, `flutter_riverpod`, `Symbols`, `appTheme`, `22_imagenes` (PaginaCarouselFotosUsuario, carousel mini), `data_find_propiedades`, `08_pantallas/inicio` (data_espacios_casas), `03_listas` (provider_me_gusta, DialogSelectorListas, page_compartir_*), `60_global_widgets` (state widgets, debugprint, monto), `app_routes`, `provider_session` (`10_user_login`) | ⚠ deuda | **588 líneas**. **`_MeGustaButtonFicha` duplica `_MeGustaButton`** de inicio → refactor `60_global_widgets/me_gusta_button.dart`. **`_FotoItemWidget`** sub-widget sin extraer → candidato a `60_global_widgets/miniaturas_carousel_widget.dart` |
| 3 | `pagina_detalle_propiedad_pdf.dart` | `PdfGeneratorService` | 311 | `pdf` (paquete pub.dev), `data_find_propiedades`, `08_pantallas/inicio` (data_espacios_casas), `dio` (HTTP para foto principal bytes), `path_provider` (mobile), `share_plus` (mobile), `url_launcher` (web) | ⚠ deuda | Servicio fat (311 líneas) acoplado a `EspaciosCasa`. Deuda: parametrizar plantilla genérica para reusar en otros reportes (ficha de grupo, lista, etc.) |

---

## Notas críticas

- **3 archivos, 957 líneas totales** — módulo compacto pero con deuda de duplicación y de mezclar UI + sub-widgets + servicio.
- **`_MeGustaButtonFicha` es duplicado** de `_MeGustaButton` en `widget_wrap_modard_card.dart` (08_pantallas/inicio) — el comportamiento es idéntico y el código similar. Refactor a `60_global_widgets/me_gusta_button.dart` reutilizable. Ambas clases usarían el mismo widget.
- **`_FotoItemWidget` extraíble**: miniaturas para saltar a foto del carousel — sub-widget razonablemente pequeño, pero vive enterrado en `PaginaDetalleWidgetState`. Refactor: extraer a `60_global_widgets` con constructor `(List<String> fotoIds, Function(int) onJump)`.
- **`PdfGeneratorService` acoplado a `EspaciosCasa`**: el generator debe aceptar cualquier modelo que cumpla con una contract (foto principal, precio, ubicación, contacto). Deuda de parametrización.
- **`data_find_propiedades.dart` no Freezed**: inconsistencia con `clase_busqueda_estado.dart` (Freezed) en el mismo hito `08_pantallas/inicio`. Migrar a Freezed para uniformidad.
- **Acoplamiento transversal esperado**:
  - `22_imagenes/PaginaCarouselFotosUsuario` para fotos.
  - `03_listas/provider_me_gusta`, `DialogSelectorListas`, `PageCompartirConConocido/Grupo` para difusión.
  - `08_pantallas/tu_cuenta/conocidos/mensajesChatProvider` para contactar al promotor.
  - `10_user_login/provider_session` para validar sesión.
  - `08_pantallas/inicio/data_espacios_casas.dart` para el modelo de la propiedad.
- **Sin fallback DB**: si la propiedad está en DB captura pero no en publicados, el detalle no la encuentra. Deuda menor.
- **Sin tests**: ninguno de los 3 archivos tiene test widget/unit. En particular el `PdfGeneratorService` merecería test visualmente (snapshot del PDF generado).
