# Epic: Landing Pages por Actor / Catálogos Públicos (03_vistas)

**Directorio:** `lib\03_vistas\`  
**Archivos:** `pagina_asociaciones.dart`, `pagina_hospedaje.dart`, `pagina_inmobiliarias.dart`, `pagina_market.dart`, `pagina_promotores.dart`, `pagina_propietarios.dart`, `pagina_proveedores.dart`, `pagina_servicios.dart`, `pagina_usuarios.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Captación de profesionales inmobiliarios | Promotor | Descubre herramientas pro (stats, herramientas, integraciones) y publica gratis | `pagina_promotores.dart` + config 4 providers → `/principal` |
| | Propietario | Publica sin intermediarios, ve beneficios y pasos | `pagina_propietarios.dart` + config 4 providers |
| | Inmobiliaria | Ve propuesta enterprise (control center, multi-agente) | `pagina_inmobiliarias.dart` (CTA "PROXIMAMENTE") |
| | Proveedor/Servicios/Hospedaje/Market/Asociaciones/Usuario | Cada segmento ve landing adaptada a su caso de uso | 9 páginas con estructura común |

---

## User Story Mapping

```
Usuario llega a landing page (Web/SEO/Referido)
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ Estructura común (9 páginas):                               │
│ - ConsumerWidget + AppBar (back condicional + título)       │
│ - SingleChildScrollView + derechosReservadosObscuro()       │
│ - Hero section con imagen + CTA principal                   │
│ - Secciones: Beneficios/Stats/Features/Pasos/Testimonios    │
│ - Footer con contacto                                       │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   CTA "Publicar"   CTA "Buscar"      CTA "Próximamente"
   (configura 4-5    (navega a        (sin acción real)
    providers +      localidades/     o navega a
    pushReplacement)  principal)       registro
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-VIST-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-VIST-001 | **Ubicuo** | El sistema proveerá **9 landing pages** (`pagina_*.dart`) como `ConsumerWidget` con estructura común: `AppBar` (leading back si `canPop`, título), `SingleChildScrollView`, secciones hero/features/beneficios/pasos/footer, `derechosReservadosObscuro()`. | `lib\03_vistas\*.dart` (todos) | En código |
| REQ-VIST-002 | **Ubicuo** | Cada landing page usará **paleta de colores y branding propio** (burdeos/dorado asociaciones, azul/ámbar hospedaje, steel blue/green inmobiliarias, violeta/ámbar market, navy/gold promotores, azul/rojo propietarios, púrpura/magenta proveedores, teal/naranja servicios, azul/ámbar usuarios). | Cada archivo: `Color(0xFF...)` en Containers/Gradients | En código |
| REQ-VIST-003 | **Evento** | Cuando el usuario toque CTA principal en **Promotores** ("Prueba Gratis"/"Publicar"), **Propietarios** ("Publicar Gratis Ahora"), **Hospedaje** ("Aquí publicaras"), el sistema configurará providers de menú (tipoEspacio, tipoTransaccion, tuCuenta, nivelGobierno) y navegará a `AppRoutes.principal` con `pushReplacementNamed`. | `pagina_promotores.dart:200-230`, `pagina_propietarios.dart:250-280`, `pagina_hospedaje.dart:180-220` | En código |
| REQ-VIST-004 | **Evento** | Cuando el usuario toque "Buscar" en `pagina_usuarios.dart`, el sistema validará CP (5 dígitos), actualizará `codigoPostalBusquedaProvider` y navegará a búsqueda de localidades. | `pagina_usuarios.dart:120-160` | En código |
| REQ-VIST-005 | **Estado** | Mientras `pagina_usuarios.dart` muestre carrusel de propiedades, el sistema consumirá `findPropiedadesEstadosde10en10Provider` (paginado 10-en-10) y renderizará cards con fallback a endpoints alternativos. | `pagina_usuarios.dart:200-350` | En código |
| REQ-VIST-006 | **No Deseado** | Si el usuario toque CTA en **Inmobiliarias**, **Market**, **Proveedores**, **Servicios**, **Asociaciones**, el sistema mostrará texto "PROXIMAMENTE..." o navegará a registro sin lógica real (placeholders). | 5 archivos: CTA sin `onPressed` real | Parcial |
| REQ-VIST-007 | **Ubicuo** | El sistema usará `material_symbols_icons` (`Symbols.*)` para toda iconografía en landings. | Todos los archivos | En código |
| REQ-VIST-008 | **Opcional** | Donde exista formulario de contacto (Inmobiliarias), el sistema usará `TextFormField` con validación básica y botón submit sin backend conectado. | `pagina_inmobiliarias.dart:300-350` | Parcial |
| REQ-VIST-009 | **Complejo** | Mientras el usuario esté en `pagina_usuarios.dart` y tenga conectividad, cuando haga scroll, el sistema cargará siguiente página de propiedades (`paramSkip += 10`) vía `findPropiedadesEstadosde10en10Provider`. | `pagina_usuarios.dart` paginación | En código |

---

## Trazabilidad a Código

| Landing Page | Actor Objetivo | CTA Principal | Providers Configurados |
|--------------|----------------|---------------|------------------------|
| `pagina_promotores.dart` | Promotor | "Prueba Gratis" / "Publicar" | 4 (tipoEspacio, tipoTransaccion, tuCuenta, nivelGobierno) |
| `pagina_propietarios.dart` | Propietario | "Publicar Gratis Ahora" | 4 (igual) |
| `pagina_hospedaje.dart` | Hospedaje | "Aquí publicaras" | 5 (+ principal) |
| `pagina_usuarios.dart` | Comprador/Arrendatario | "Buscar" (CP) + "Ver todas" | `codigoPostalBusquedaProvider` + navega principal |
| `pagina_inmobiliarias.dart` | Inmobiliaria | "PROXIMAMENTE REGISTRO" | — |
| `pagina_market.dart` | Retail/Market | "AQUÍ PODRAS SUBIR..." | — |
| `pagina_proveedores.dart` | Proveedores | "PROXIMAMENTE..." | — |
| `pagina_servicios.dart` | Servicios | "PROXIMAMENTE CREAR..." | — |
| `pagina_asociaciones.dart` | Asociaciones | "Proximamente Registro" | — |

---

## Notas de Arquitectura

- **9 páginas, 1 patrón**: Copy-paste intensivo con variaciones de color/texto — candidatas a refactor con widget paramétrico.
- **Solo 4/9 tienen CTA funcional**: Promotores, Propietarios, Hospedaje, Usuarios. El resto son placeholders.
- **`pagina_usuarios.dart` es híbrida**: Landing + búsqueda en vivo conectada a BD (paginación 10-en-10).
- **Colores hardcoded**: Cada página usa `Color(0xFF...)` directo — **violación de `ui_exceptions.dart`** (no documentadas como excepciones).