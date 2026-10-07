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
| REQ-PROP-004 | **Estado** | Mientras se muestre la ficha, el sistema mostrará la sección «Datos del contacto» (nombre, teléfono, correo) como texto. **No existe** un CTA «Contactar» ni apertura de chat desde `PaginaDetalleWidget`. | `pagina_detalle_propiedad.dart` (`_buildDatoContacto`) | Parcial |
| REQ-PROP-005 | **Evento** | Cuando el usuario toque «Compartir» en el carrusel de fotos de `22_imagenes`, el sistema navegará a `PageCompartirConGrupo` o `PageCompartirConConocido` (de `03_listas`). El botón **no está** en `PaginaDetalleWidget`. | `22_imagenes/inicio_fotos_usuario/pagina_carousel_fotos_usuario.dart:563,585` | En código (otro módulo) |
| REQ-PROP-006 | **Evento** | Cuando el usuario toque «Guardar en lista» en el carrusel de fotos de `22_imagenes`, el sistema abrirá `DialogSelectorListas` (`03_listas`). `PaginaDetalleWidget.fromChatUserId` está declarado pero **no se usa** en la pantalla. | `pagina_carousel_fotos_usuario.dart:517-523`, `pagina_detalle_propiedad.dart:32` | Parcial |
| REQ-PROP-007 | **Ubicuo** | El sistema implementará `PdfGeneratorService.generarYDescargarPDF(propiedad, idFotoPrincipal, idsGaleria)` (arma PDF carta con imagen, precios, datos, ubicación, contacto y galería, y lo abre con `Printing`). **Ningún archivo de `lib/` lo invoca**, por lo que la exportación no es accesible al usuario. | `pagina_detalle_propiedad_pdf.dart:12-136` | Implementado, sin invocar |
| REQ-PROP-008 | **No Deseado** | Si `findPropiedades` retorna 0 docs (idPropiedad inválido o no encontrado), el sistema mostrará `stateErrorFS` con mensaje "Propiedad no encontrada" y CTA volver. | `FutureBuilderStateWidgets.stateErrorFS` | En código |
| REQ-PROP-009 | **Ubicuo** | El sistema usará el paquete `pdf` (`pub.dev/packages/pdf`) para generar la ficha técnica PDF con imagen, datos y branding Buscobien. | `pagina_detalle_propiedad_pdf.dart` | En código |
| REQ-PROP-010 | **Ubicuo** | El sistema mostrará los datos de la propiedad en un `SingleChildScrollView` con ancho máximo `desktopContentMaxWidth`, márgenes de 15 px en pantallas estrechas y 40 px en anchas, y omitirá los campos vacíos o con valor `"0"` (`valoresVacios = ["", "0"]`). | `pagina_detalle_propiedad.dart:54,68-215`; SDD_08_pantallas_propiedades §2 | En código |
| REQ-PROP-011 | **Estado** | Mientras la ficha se muestre, el sistema cargará la foto principal con `recuperaFotoPorIdFoto` («Sin foto» si no hay id; ícono de imagen rota si falla) y la galería con `recuperaIdsFotosDePropiedades` y `recuperaFotosOrdenadasIdProperty`, usando el orden de los ids como respaldo si el orden guardado no responde 200. | `pagina_detalle_propiedad.dart:361-510`; SDD_08_pantallas_propiedades §3–§5 | En código |
| REQ-PROP-012 | **Ubicuo** | El sistema mostrará las características adicionales (`listamasdatos`) como chips con ícono y texto. | `pagina_detalle_propiedad.dart:217-276`; SDD_08_pantallas_propiedades §4 | En código |

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
