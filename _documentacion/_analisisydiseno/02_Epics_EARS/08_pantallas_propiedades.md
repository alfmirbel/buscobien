# Epic: Pantallas — Detalle de Propiedad y Exportación PDF (08_pantallas/propiedades)

**Directorio:** `lib\08_pantallas\propiedades\`
**Archivos fuente:** 3 `.dart` — `data_find_propiedades.dart`, `pagina_detalle_propiedad.dart`, `pagina_detalle_propiedad_pdf.dart`
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Decisión informada de compra/renta | Comprador/Arrendatario | Ve detalle completo de una propiedad: fotos carousel, precio, ubicación, contacto promotor, Me Gusta, "contactar", "compartir" | `PaginaDetalleWidget` (588 líneas) |
| | Sistema | Genera PDF exportable de la ficha técnica | `PdfGeneratorService` (311 líneas) |
| | Negocio | Captura lead mediante CTA contacto al promotor | CTAs en ficha |

---

## User Story Mapping

```
Usuario llega desde catálogo (03_vistas / inicio) o listas (03_listas)
   │
   ▼
PaginaDetalleWidget (ConsumerStatefulWidget)
   ├── initState: fetch `findPropiedades` para idPropiedad
   ├── build():
   │   ├── Carousel fotos completo (PaginaCarouselFotosUsuario de 22_imagenes)
   │   ├── Ficha técnica (precio, ubicación, características)
   │   ├── _FotoItemWidget (miniaturas)
   │   ├── _MeGustaButtonFicha
   │   └── CTAs: Contactar, Compartir (conocido/grupo), Guardar lista, Exportar PDF
   └── onExportPDF: PdfGeneratorService.generate(data) → save/share
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-PROP-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-PROP-001 | **Ubicuo** | El sistema expondrá modelos `FindPropiedades`, `Doc` para tipar la respuesta Mango `$in` bulk de una lista de IDs. | `data_find_propiedades.dart` (58 líneas) | En código |
| REQ-PROP-002 | **Evento** | Cuando el usuario navegue a `PaginaDetalleWidget` con `idPropiedad`, el sistema hará fetch vía `findPropiedades([idPropiedad])` (Mango `$in`) y renderizará Carousel + ficha técnica + CTAs. | `pagina_detalle_propiedad.dart:1-588` | En código |
| REQ-PROP-003 | **Estado** | Mientras el usuario esté en la ficha de detalle, el sistema mantendrá un `_FotoItemWidget` (miniaturas) y un `_MeGustaButtonFicha` (toggle Me Gusta optimistic). | `pagina_detalle_propiedad.dart:_FotoItemWidget`, `_MeGustaButtonFicha` | En código |
| REQ-PROP-004 | **Evento** | Cuando el usuario toque CTA "Contactar", el sistema abrirá chat con el promotor (creando conversación si no existe en `buscobien_mensajes`). | CTAs del `PaginaDetalleWidget`) | En código |
| REQ-PROP-005 | **Evento** | Cuando el usuario toque CTA "Compartir", el sistema navegará a `PageCompartirConConocido/Grupo` (de `03_listas`). | CTA "Compartir" | En código |
| REQ-PROP-006 | **Evento** | Cuando el usuario toque CTA "Guardar en lista", el sistema abrirá `DialogSelectorListas` (de `03_listas`). | CTA "Guardar en lista" | En código |
| REQ-PROP-007 | **Evento** | Cuando el usuario toque CTA "Exportar PDF", el sistema invocará `PdfGeneratorService.generate(propiedad)` (de `pagina_detalle_propiedad_pdf.dart`) y abrirá / compartirá el PDF. | `pagina_detalle_propiedad_pdf.dart:PdfGeneratorService` (311 líneas) | En código |
| REQ-PROP-008 | **No Deseado** | Si `findPropiedades` retorna 0 docs (idPropiedad inválido o no encontrado), el sistema mostrará `stateErrorFS` con mensaje "Propiedad no encontrada" y CTA volver. | `FutureBuilderStateWidgets.stateErrorFS` | En código |
| REQ-PROP-009 | **Ubicuo** | El sistema usará el paquete `pdf` (`pub.dev/packages/pdf`) para generar la ficha técnica PDF con imagen, datos y branding Buscobien. | `pagina_detalle_propiedad_pdf.dart` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `FindPropiedades`, `Doc` | `data_find_propiedades.dart` | 58 |
| `PaginaDetalleWidget`, `PaginaDetalleWidgetState` | `pagina_detalle_propiedad.dart` | 1-200 aprox |
| `_FotoItemWidget` | `pagina_detalle_propiedad.dart` | (anidado) |
| `_MeGustaButtonFicha` | `pagina_detalle_propiedad.dart` | (anidado) |
| `PdfGeneratorService` | `pagina_detalle_propiedad_pdf.dart` | 1-311 |

---

## Deuda Técnica

1. **`pagina_detalle_propiedad.dart` 588 líneas** con 2 sub-widgets anidados (`_FotoItemWidget`, `_MeGustaButtonFicha`). Refactor: extraer `_MeGustaButtonFicha` a `60_global_widgets` (es casi idéntica a `_MeGustaButton` de inicio — duplicación latente).
2. **`PdfGeneratorService` 311 líneas**: fat service. Podría parametrizar plantillas de PDF para reusar en otros contextos (ej. reportes, listas).
3. **Acoplamiento con `22_imagenes`** (Carousel), `03_listas` (Compartir, Guardar en lista, Me Gusta provider) y `08_pantallas/tu_cuenta` (mensajes chat). Esperado y documentable.
4. **Sin tests**.
