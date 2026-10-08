# Registro de decisiones de arquitectura (ADR)

**Creado:** 2026-10-07 a partir del código y de los documentos del proyecto.  
**Nota:** el motivo original de cada decisión no quedó documentado en su momento; el campo *Contexto* resume la evidencia verificable y las *Consecuencias* lo observado en el código. Para nuevas decisiones usar la plantilla del final.

| ID | Decisión | Estado |
| :--- | :--- | :--- |
| ADR-001 | Riverpod 3 con generación de código para el estado | Vigente |
| ADR-002 | Modelos inmutables con Freezed + json_serializable | Vigente |
| ADR-003 | Navegación con `Navigator` 1.0 y `onGenerateRoute` (sin GoRouter) | Vigente |
| ADR-004 | Navegación de menús por estado global (`HomeNavigation`) | Vigente |
| ADR-005 | CouchDB como almacén único, con Mango y vistas | Vigente |
| ADR-006 | Cliente accede directo a CouchDB con Basic Auth | **Temporal — a reemplazar** (nginx + API + JWT) |
| ADR-007 | Sesión con `SessionStorage` por plataforma | Vigente (sin JWT real) |
| ADR-008 | Compilación Web con WebAssembly (`--wasm`) | Vigente |
| ADR-009 | Material Design 3 con `ColorScheme` global `appTheme` | Vigente |
| ADR-010 | Microservicio de correo independiente (`buscobien-mailer`) | Vigente |

---

## ADR-001 — Riverpod 3 con generación de código
- **Contexto:** `pubspec.yaml` declara `flutter_riverpod ^3.0.3`, `riverpod_annotation ^4.0.2`, `riverpod_generator ^4.0.3` y `riverpod_lint`.
- **Decisión:** el estado compartido vive en providers/notifiers Riverpod; los anotados con `@riverpod` requieren `build_runner`.
- **Consecuencias:** código generado (`*.g.dart`) en el repositorio; las vistas no contienen lógica de negocio. Coexisten providers `StateProvider`/`StateNotifier` heredados (paquete `flutter_riverpod/legacy`).

## ADR-002 — Freezed + json_serializable
- **Contexto:** `freezed_annotation ^3.1.0`, `freezed ^3.2.5`.
- **Decisión:** modelos de datos inmutables con `copyWith` y serialización JSON generada.
- **Consecuencias:** archivos `*.freezed.dart`/`*.g.dart`. Algunos modelos (p. ej. `FindPropiedades`, modelos de grupos) usan JSON manual: inconsistencia conocida.

## ADR-003 — `Navigator` 1.0 con `onGenerateRoute`
- **Contexto:** `lib/07_routes/app_routes.dart` define 22 constantes y un `switch` único; no se usa GoRouter ni Navigator 2.0.
- **Decisión:** rutas con nombre y argumentos mediante `settings.arguments`.
- **Consecuencias:** argumentos sin tipado estático (casts `as`), ruta desconocida devuelve `null`; ver [`SDD_07_routes.md`](../modulos_sdd/07_routes/SDD_07_routes.md).

## ADR-004 — Navegación de menús por estado global
- **Contexto:** `HomeNavigation` (`01_home`) guarda 7 índices (`indiceInicial`, `indicePrincipal`, …) y un contador `version`.
- **Decisión:** los menús y pestañas se sincronizan con ese estado en lugar de rutas.
- **Consecuencias:** URLs no reflejan la sección activa; `version` fuerza reconstrucciones.

## ADR-005 — CouchDB como almacén único
- **Contexto:** 35 bases referenciadas en el código ([inventario](../../06_modelo_de_datos_y_bd/bases_de_datos_en_codigo.md)); consultas Mango (`_find`) y vistas MapReduce.
- **Decisión:** todo el dominio (usuarios, propiedades, listas, red social, fotos, SEPOMEX) se guarda en CouchDB; las fotos se almacenan en bases propias.
- **Consecuencias:** sin relaciones ni transacciones (operaciones multi-documento sin atomicidad, p. ej. publicar propiedad con reversión manual); design documents sin versionar (solo existe `server/setup_couchdb_propietarios.sh`).

## ADR-006 — Acceso directo cliente → CouchDB (temporal)
- **Contexto:** `direccionip`, `username` y `password` (de `--dart-define`) se usan en 34 archivos con `Authorization: Basic`; no hay API intermedia en producción.
- **Decisión (vigente de hecho):** el cliente consulta y escribe en CouchDB directamente.
- **Consecuencias:** credenciales de administrador dentro de la app, autenticación y autorización en el cliente; riesgos T1–T4 de [`modelo_de_amenazas.md`](../modelo_de_amenazas.md).
- **Plan:** reemplazar por *Flutter → nginx → API Node.js → CouchDB* con JWT; **pendiente de la configuración de nginx y JWT**. Mientras tanto no se corrige en el código.

## ADR-007 — Sesión con `SessionStorage` por plataforma
- **Contexto:** `session_storage.dart`: `WebSessionStorage` (`shared_preferences`) si `kIsWeb`, `MobileSessionStorage` (`flutter_secure_storage`) en las demás plataformas.
- **Decisión:** persistir datos de sesión localmente según plataforma.
- **Consecuencias:** `AuthState.jwtToken` existe pero no se obtiene de ningún servicio todavía.

## ADR-008 — Web con WebAssembly
- **Contexto:** regla del proyecto: `flutter build web --wasm`.
- **Decisión:** compilar la versión Web con WASM; verificar la compatibilidad WASM de cada paquete nuevo.
- **Consecuencias:** `google_maps_flutter` usa *platform views*, lo que puede limitar WASM (alternativa evaluada en documentación: `flutter_map`).

## ADR-009 — Material Design 3 con `appTheme`
- **Contexto:** [`antigravity_ui_rules.md`](../../05_desarrollo_y_especificaciones_tecnicas/antigravity_ui_rules.md).
- **Decisión:** `useMaterial3: true`; los colores salen únicamente de `appTheme` (`lib/20_var_globales/var_color_themes.dart`); íconos Material Symbols.
- **Consecuencias:** el cambio de esquema de colores (`04_provider`) se aplica globalmente.

## ADR-010 — Microservicio de correo independiente
- **Contexto:** `server/buscobien-mailer/` (Express, nodemailer, pm2, Apache como proxy).
- **Decisión:** el envío de correos de recuperación se aísla en un servicio propio con credenciales SMTP en su `.env`.
- **Consecuencias:** endpoint sin autenticación y por HTTP desde la app (T5–T7). Contrato en [`contrato_api_actual.md`](../contrato_api_actual.md).

---

## Plantilla

```markdown
## ADR-0NN — Título
- **Contexto:** hechos y restricciones (con evidencia).
- **Decisión:** qué se decide.
- **Consecuencias:** efectos positivos y negativos, riesgos.
- **Estado:** Propuesta | Vigente | Temporal | Reemplazada por ADR-0MM
```
