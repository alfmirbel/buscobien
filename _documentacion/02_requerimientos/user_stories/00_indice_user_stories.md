# Índice de historias de usuario

**Generado:** 2026-10-07 por [`generar_indice_historias.py`](../generar_indice_historias.py) — no editar a mano.  
**Total:** 129 historias en 26 archivos (uno por módulo de `lib/`). Cada módulo tiene su Epic en [`epics_ears/`](../epics_ears/).

| Módulo | Archivo | Historias | REQ en la Epic |
| :--- | :--- | ---: | ---: |
| `01_home` | [01_home.md](01_home.md) | 2 | 8 |
| `01_splash_screen` | [01_splash_screen.md](01_splash_screen.md) | 2 | 10 |
| `02_principal_screen` | [02_principal_screen.md](02_principal_screen.md) | 5 | 10 |
| `03_listas` | [03_listas.md](03_listas.md) | 7 | 11 |
| `03_vistas` | [03_vistas.md](03_vistas.md) | 4 | 9 |
| `04_provider` | [04_provider.md](04_provider.md) | 3 | 7 |
| `05_provider_menus` | [05_provider_menus.md](05_provider_menus.md) | 5 | 10 |
| `07_routes` | [07_routes.md](07_routes.md) | 4 | 17 |
| `08_pantallas_inicio` | [08_pantallas_inicio.md](08_pantallas_inicio.md) | 6 | 8 |
| `08_pantallas_perfil` | [08_pantallas_perfil.md](08_pantallas_perfil.md) | 5 | 8 |
| `08_pantallas_propiedades` | [08_pantallas_propiedades.md](08_pantallas_propiedades.md) | 8 | 12 |
| `08_pantallas_tu_cuenta_conocidos` | [08_pantallas_tu_cuenta_conocidos.md](08_pantallas_tu_cuenta_conocidos.md) | 6 | 11 |
| `08_pantallas_tu_cuenta_grupos` | [08_pantallas_tu_cuenta_grupos.md](08_pantallas_tu_cuenta_grupos.md) | 11 | 16 |
| `08_pantallas_tu_cuenta_tus_espacios` | [08_pantallas_tu_cuenta_tus_espacios.md](08_pantallas_tu_cuenta_tus_espacios.md) | 10 | 14 |
| `08_pantallas_ubicacion` | [08_pantallas_ubicacion.md](08_pantallas_ubicacion.md) | 4 | 8 |
| `08_pantallas_widgets_comunes` | [08_pantallas_widgets_comunes.md](08_pantallas_widgets_comunes.md) | 5 | 7 |
| `10_user_login` | [10_user_login.md](10_user_login.md) | 7 | 12 |
| `12_localidades_user` | [12_localidades_user.md](12_localidades_user.md) | 2 | 7 |
| `14_geolocalizacion` | [14_geolocalizacion.md](14_geolocalizacion.md) | 4 | 10 |
| `20_var_globales` | [20_var_globales.md](20_var_globales.md) | 6 | 12 |
| `22_imagenes` | [22_imagenes.md](22_imagenes.md) | 5 | 12 |
| `40_security` | [40_security.md](40_security.md) | 5 | 9 |
| `41_connectivity` | [41_connectivity.md](41_connectivity.md) | 2 | 10 |
| `42_sistema_operativo` | [42_sistema_operativo.md](42_sistema_operativo.md) | 1 | 9 |
| `60_global_widgets` | [60_global_widgets.md](60_global_widgets.md) | 7 | 11 |
| `main` | [main.md](main.md) | 3 | 10 |

## Detalle

### `01_home`

- **US-HOME-001** — Navegación Global con 7 Dimensiones Independientes
- **US-HOME-002** — Versioning para Rebuild Granular

### `01_splash_screen`

- **US-SPLASH-001** — Splash con Timer Mínimo y Gate de Conectividad
- **US-SPLASH-002** — Historial de Versiones Inmutable

### `02_principal_screen`

- **US-PRIN-001** — Shell Principal con 5 Secciones y Slivers Condicionales
- **US-PRIN-002** — AppBar Dinámico según Estado de Sesión
- **US-PRIN-003** — Drawer Lateral con 11 Items y Navegación
- **US-PRIN-004** — Inicio con Hero, 3 Tarjetas Responsivas y Hover Animado
- **US-PRIN-005** — Listener Reactivo de Conectividad Integrado

### `03_listas`

- **US-LIST-001** — Ver hub central de Listas con 3 pestañas (Propias / Recibidas / Enviadas)
- **US-LIST-002** — Crear una lista propia con ID SHA1 determinista
- **US-LIST-003** — Agregar o quitar una propiedad a una lista existente vía Dialog selector
- **US-LIST-004** — Compartir una lista con hasta 5 conocidos/grupos + notificación chat
- **US-LIST-005** — Compartir una propiedad individual a un Conocido o a un Grupo + chat
- **US-LIST-006** — Marcar Me Gusta en una propiedad y auto-crear lista "Favoritas"
- **US-LIST-007** — Ver detalle de una lista (propia o compartida) con bulk fetch `$in` Mango query

### `03_vistas`

- **US-VIST-001** — Ver una landing page por segmento con estructura M3 común (cita: REQ-VIST-001, REQ-VIST-002, REQ-VIST-007)
- **US-VIST-002** — Convertirme en promotor / propietario / hospedaje con un solo CTA funcional (cita: REQ-VIST-003)
- **US-VIST-003** — Buscar propiedades viales por código postal desde la landing Usuarios (cita: REQ-VIST-004, REQ-VIST-005, REQ-VIST-009)
- **US-VIST-004** — Ver placeholder informativo en Inmobiliarias / Market / Proveedores / Servicios / Asociaciones (cita: REQ-VIST-006, REQ-VIST-008)

### `04_provider`

- **US-PROV-001** — Seleccionar tema de color M3 con cambio inmediato reactivo (cita: REQ-PROV-001, REQ-PROV-003, REQ-PROV-004)
- **US-PROV-002** — Tema por defecto `lightPAN` (rosa) para usuarios nuevos (cita: REQ-PROV-005, REQ-PROV-007)
- **US-PROV-003** — Persistencia ausente del tema (deuda técnica registrada) (cita: REQ-PROV-006)

### `05_provider_menus`

- **US-MENU-001** — 7 Menús con Tabs Sincronizados por 5 Dimensiones de Filtrado
- **US-MENU-002** — Menú "Nivel de Gobierno" con Tabs Dinámicos por Código Postal
- **US-MENU-003** — Menú "Tu Cuenta" Diferenciado por Rol (Promotor vs Usuario)
- **US-MENU-004** — Dropdown de Tipo de Inmueble con Variable Global Compartida
- **US-MENU-005** — MenuInferiorTipoDeTransaccion — Tabs Estándar en el Cuerpo

### `07_routes`

- **US-ROUT-001** — Navegación centralizada con argumentos tipados
- **US-ROUT-002** — Deep Link recuperación contraseña multiplataforma
- **US-ROUT-003** — Manejo de errores de navegación
- **US-ROUT-004** — Arranque con splash y enlace inicial (cita: REQ-ROUT-013, REQ-ROUT-014, REQ-ROUT-015, REQ-ROUT-017)

### `08_pantallas_inicio`

- **US-INI-001** — Ver catálogo paginado de propiedades destacadas en Inicio (cita: REQ-INI-002, REQ-INI-005)
- **US-INI-002** — Paginar propiedades 10-en-10 con scroll infinito (cita: REQ-INI-001, REQ-INI-003)
- **US-INI-003** — Toggle Me Gusta en tarjeta de propiedad con optimistic update (cita: REQ-INI-004)
- **US-INI-004** — Ver contador de propiedades totales con filtros activos (cita: REQ-INI-007)
- **US-INI-005** — Aplicar filtros avanzados del catálogo "Otras características" (cita: REQ-INI-006)
- **US-INI-006** — Recuperación de catálogo tras falla HTTP con endpoints fallback (cita: REQ-INI-007)

### `08_pantallas_perfil`

- **US-PERF-001** — Ver mi perfil con avatar, rol y datos de contacto (cita: REQ-PERF-001, REQ-PERF-002, REQ-PERF-003, REQ-PERF-007, REQ-PERF-008)
- **US-PERF-002** — Editar mis datos de perfil (nombre, email, celular, RFC) (cita: REQ-PERF-004)
- **US-PERF-003** — Gestionar mi avatar (subir/preview/guardar) (cita: REQ-PERF-005)
- **US-PERF-004** — Reactividad del perfil a login/logout (cita: REQ-PERF-006)
- **US-PERF-005** — Deuda de sesión parcial (campos null como string) (cita: REQ-PERF-007)

### `08_pantallas_propiedades`

- **US-PROP-001** — Ver detalle completo de una propiedad con carousel y ficha técnica (cita: REQ-PROP-001, REQ-PROP-002, REQ-PROP-003, REQ-PROP-008)
- **US-PROP-002** — Contactar al promotor iniciando conversación de chat (cita: REQ-PROP-004)
- **US-PROP-003** — Compartir o guardar la propiedad en una lista (cita: REQ-PROP-005, REQ-PROP-006)
- **US-PROP-004** — Generar y compartir PDF de la ficha técnica de la propiedad (cita: REQ-PROP-007, REQ-PROP-009)
- **US-PROP-005** — Toggle Me Gusta desde la ficha de detalle (cita: REQ-PROP-003)
- **US-PROP-006** — Ficha legible en cualquier pantalla (cita: REQ-PROP-010)
- **US-PROP-007** — Fotos de la propiedad con respaldo (cita: REQ-PROP-011)
- **US-PROP-008** — Características adicionales como chips (cita: REQ-PROP-012)

### `08_pantallas_tu_cuenta_conocidos`

- **US-CON-001** — Ver mis contactos (lista de conocidos) (cita: REQ-CON-002, REQ-CON-003)
- **US-CON-002** — Descubrir usuarios nuevos e invitarlos a ser mis conocidos (cita: REQ-CON-004, REQ-CON-005)
- **US-CON-003** — Aceptar o rechazar invitaciones recibidas (crear relación bidireccional) (cita: REQ-CON-005, REQ-CON-006, REQ-CON-010)
- **US-CON-004** — Ver perfil de un contacto con CTAs condicionales (cita: REQ-CON-011)
- **US-CON-005** — Chatear 1:1 con texto, propiedad o lista (cita: REQ-CON-007, REQ-CON-008, REQ-CON-009)
- **US-CON-006** — Hub ConocidosView con 3 tabs sincronizados (cita: REQ-CON-002)

### `08_pantallas_tu_cuenta_grupos`

- **US-GPU-001** — Ver Mis Grupos (lista de miembros) (cita: REQ-GPU-002, REQ-GPU-003)
- **US-GPU-002** — Ver detalle completo de un grupo (Publicaciones / Miembros / Avisos / Chat) (cita: REQ-GPU-004, REQ-GPU-005, REQ-GPU-006)
- **US-GPU-003** — Administrar membresías (invitar / aceptar / unirse / eliminar) (cita: REQ-GPU-007, REQ-GPU-008)
- **US-GPU-004** — Chatear en el grupo (grupal con propiedad/lista) (cita: REQ-GPU-009, REQ-GPU-010, REQ-GPU-012)
- **US-GPU-005** — Publicar y recibir avisos internos del grupo (sólo admin crea) (cita: REQ-GPU-006)
- **US-GPU-006** — Compartir propiedades en el grupo (PublicacionesGrupo) (cita: REQ-GPU-005)
- **US-GPU-007** — Hub GruposView 3 tabs con badge (cita: REQ-GPU-002)
- **US-GPU-008** — Crear un grupo (cita: REQ-GPU-013)
- **US-GPU-009** — Responder una invitación de grupo (cita: REQ-GPU-014)
- **US-GPU-010** — Detalle del grupo según mi rol (cita: REQ-GPU-015)
- **US-GPU-011** — Avisos del grupo con límite de 250 caracteres (cita: REQ-GPU-016)

### `08_pantallas_tu_cuenta_tus_espacios`

- **US-TUS-001** — Ver hub central de "Tus Espacios" (mis propiedades) (cita: REQ-ESP-001, REQ-ESP-002, REQ-ESP-007)
- **US-TUS-002** — Crear ficha de captura (alta de propiedad) usando wizard con campos por tipo inmueble (cita: REQ-ESP-003, REQ-ESP-005)
- **US-TUS-003** — Publicar propiedad a CouchDB vía API con manejo 409 (cita: REQ-ESP-006)
- **US-TUS-004** — Editar ficha existente precargada (cita: REQ-ESP-004, REQ-ESP-006)
- **US-TUS-005** — Comprar un espacio / adquirir propiedad de mercado secundario (cita: REQ-ESP-008)
- **US-TUS-006** — Configuración hardcoded de campos por tipo inmueble (deuda) (cita: REQ-ESP-005, REQ-ESP-010)
- **US-TUS-007** — Vista de Tus Espacios según el tipo de usuario (cita: REQ-ESP-011)
- **US-TUS-008** — Ficha de propiedad con estado y acciones (cita: REQ-ESP-012)
- **US-TUS-009** — Editar la propiedad en cinco pasos (cita: REQ-ESP-013)
- **US-TUS-010** — Publicar y dejar de publicar una propiedad (cita: REQ-ESP-014)

### `08_pantallas_ubicacion`

- **US-UBIC-001** — Ver hub de mis localidades guardadas (cita: REQ-UBIC-004)
- **US-UBIC-002** — Buscar localidades por código postal y visualizar en Google Maps (cita: REQ-UBIC-005, REQ-UBIC-007, REQ-UBIC-008)
- **US-UBIC-003** — Vista alternativa maestra de localidades (duplicación histórica) (cita: REQ-UBIC-006)
- **US-UBIC-004** — Filtrar catálogo de propiedades por CP seleccionado (cita: REQ-UBIC-007)

### `08_pantallas_widgets_comunes`

- **US-WC-001** — Mostrar letrero de precio según tipo de transacción
- **US-WC-002** — Widget `letrerprecio` no contiene lógica de negocio
- **US-WC-003** — Tipo de transacción desconocida muestra texto vacío
- **US-WC-004** — Letrero usa colores consistentes con appTheme global
- **US-WC-005** — Letrero aparece en todas las cards del catálogo

### `10_user_login`

- **US-AUTH-001** — Login Multi-Rol con Secure Storage y Restauración de Sesión
- **US-AUTH-002** — Registro Multi-Rol con TyC/Privacidad PDF y Anti-Duplicado
- **US-AUTH-003** — Recuperación de Password vía Email con Token 1 Hora y Deep Link
- **US-AUTH-004** — Gestión de Avatar con FilePicker, Base64 y Persistencia en CouchDB
- **US-AUTH-005** — Logout con Limpieza de Sesión Local y Estado Auth Restaurado a Initial
- **US-AUTH-007** — Elegir perfil de usuario al iniciar sesión (cita: REQ-AUTH-011)
- **US-AUTH-008** — Aviso de aplicación en pruebas (cita: REQ-AUTH-012)

### `12_localidades_user`

- **US-LOCU-001** — CRUD Localidades del Usuario con Anti-Duplicado y Consumo SEPOMEX
- **US-LOCU-002** — Consumo de Localidades por el Menú "Nivel de Gobierno"

### `14_geolocalizacion`

- **US-GEO-001** — Mapa de Propiedades con Markers Personalizados (Precio + Color Transacción)
- **US-GEO-002** — Geocodificación Dual Plataforma (Nativo Android/iOS + REST Web/Windows)
- **US-GEO-003** — Gestión de Permisos de Ubicación con Estados Explícitos
- **US-GEO-004** — Inyección Segura de API Keys Google Maps en Compile-Time

### `20_var_globales`

- **US-VAR-001** — appTheme — Única Fuente de Color M3 (0 Hardcoded Colors)
- **US-VAR-002** — Breakpoints Responsivos M3 Estándar + Helpers
- **US-VAR-003** — 150+ Elementos de Menú con Symbols Icons (Rango 0xe000-0xe900)
- **US-VAR-004** — Constantes UI Globales (30+ Dimensiones) + AppBar Factories
- **US-VAR-005** — Formato Timestamp Chat + Códigos Error CouchDB ES/EN
- **US-VAR-006** — Excepción de Color Documentada y Controlada (loginPrimaryBrand)

### `22_imagenes`

- **US-IMG-001** — Ver fotos de una propiedad en carousel responsivo (cita: REQ-IMG-002, REQ-IMG-003)
- **US-IMG-002** — Gestionar fotos de una propiedad en tres vistas sincronizadas (cita: REQ-IMG-004, REQ-IMG-005, REQ-IMG-008, REQ-IMG-011)
- **US-IMG-003** — Subir múltiples fotos comprimidas a una propiedad (cita: REQ-IMG-006, REQ-IMG-009, REQ-IMG-010, REQ-IMG-012)
- **US-IMG-004** — Reordenar fotos con drag & drop y persistir el orden en CouchDB (cita: REQ-IMG-007)
- **US-IMG-005** — Modelar datos de fotos y orden con Freezed/json_serializable (cita: REQ-IMG-001, REQ-IMG-002, REQ-IMG-004, REQ-IMG-006, REQ-IMG-007)

### `40_security`

- **US-SEC-001** — Credenciales CouchDB nunca en código Flutter (inyección compile-time) (cita: REQ-SEC-001)
- **US-SEC-002** — Validar passwords con SHA-256 (nunca texto plano) (cita: REQ-SEC-002, REQ-SEC-007, REQ-SEC-009)
- **US-SEC-003** — Generar token de recuperación con expiración 1 hora (cita: REQ-SEC-003, REQ-SEC-004)
- **US-SEC-004** — Tipificar 5 tipos de espacio → 10 bases CouchDB segregadas (cita: REQ-SEC-005)
- **US-SEC-005** — AES-256 legacy y storage de JWT por plataforma (deuda migración) (cita: REQ-SEC-006, REQ-SEC-008)

### `41_connectivity`

- **US-CONN-001** — Detección reactiva de conectividad (WiFi/Mobile/Ethernet/None) (cita: REQ-CONN-001)
- **US-CONN-002** — Pantalla sin conexión con auto-recovery al volver la red (cita: REQ-CONN-002)

### `42_sistema_operativo`

- **US-OS-001** — Detectar plataforma en runtime para elegir estrategia (cita: REQ-OS-001)

### `60_global_widgets`

- **US-GW-001** — Componentes base M3 para formularios y botones (cita: REQ-GW-001, REQ-GW-002, REQ-GW-003, REQ-GW-011)
- **US-GW-002** — Estado estandarizado de FutureBuilder (carga / error / vacío / activo) (cita: REQ-GW-008)
- **US-GW-003** — Logging granular con 21 niveles controlable sin recompilar (cita: REQ-GW-005)
- **US-GW-004** — Mostrar diálogo modal con `showMessageDialog` estilizado M3 (cita: REQ-GW-007)
- **US-GW-005** — Footer de derechos reservados en toda la app (cita: REQ-GW-006)
- **US-GW-006** — Generar y formatear montos de demostración (cita: REQ-GW-009)
- **US-GW-007** — Deuda de estado compartido en `MyTextFieldPassword` (no deseado) (cita: REQ-GW-010)

### `main`

- **US-MAIN-001** — Arranque Multiplataforma M3
- **US-MAIN-002** — Deep Link Recuperación Contraseña
- **US-MAIN-003** — Logging Granular por 21 Niveles

La relación historia ↔ requerimiento (citada y propuesta) está en [`matriz_trazabilidad_ears_bdd_sdd.md`](../../03_analisis_funcional/matriz_trazabilidad_ears_bdd_sdd.md).
