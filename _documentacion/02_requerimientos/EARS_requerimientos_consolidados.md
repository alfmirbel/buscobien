# Marco de Requerimientos EARS y Historias de Usuario — BuscoBien

> **Nota de exactitud (2026-10-07):** donde este documento menciona Dio, interceptor JWT o que Flutter no toca CouchDB, describe la arquitectura **objetivo**. El código actual usa el paquete `http`, Basic Auth contra CouchDB con credenciales compiladas (`--dart-define`) y no obtiene ni envía JWT; `SessionStorage` usa `flutter_secure_storage` en Android/iOS/Windows y `shared_preferences` solo en Web. Ver [arquitectura general](../04_arquitectura_y_diseno/arquitectura_general_buscobien.md).

**Fase de SDLC:** Etapa 2 — Ingeniería de Requerimientos  
**Sintaxis de Especificación:** Notación EARS (*Easy Approach to Requirements Syntax*) + User Stories (Scrum/Agile)  
**Última consolidación:** 2026-09-29  

---

## 1. Estructura de la Notación EARS en BuscoBien

La notación **EARS** se utiliza para definir requerimientos del sistema sin ambigüedades utilizando 5 patrones sintácticos formales:

1. **Ubicuidad (Ubiquitous)**: *El sistema DEBERÁ [acción].*
2. **Eventos (Event-driven)**: *CUANDO [evento Trigger], el sistema DEBERÁ [acción].*
3. **Estados (State-driven)**: *MIENTRAS [estado], el sistema DEBERÁ [acción].*
4. **Opciones (Optional Feature)**: *DONDE [característica opcional presente], el sistema DEBERÁ [acción].*
5. **Requerimientos Complejos (Complex)**: *MIENTRAS [estado], CUANDO [evento], el sistema DEBERÁ [acción].*

---

## 2. Resumen Consolidado de Requerimientos EARS por Módulo

| Módulo Fuente | Dominio de Negocio | Tipo Requerimiento EARS | Descripción del Requerimiento |
| :--- | :--- | :--- | :--- |
| `01_home` | Estado de Navegación | Ubicuo / Reactivo | El sistema DEBERÁ mantener un estado inmutable `HomeState` sincronizado reactivamente con Riverpod `HomeNavigation`. |
| `01_splash_screen` | Inicio y Warm-up | Event-driven | CUANDO se inicie la aplicación, el sistema DEBERÁ ejecutar de forma asíncrona la comprobación de conectividad e inicialización GPS. |
| `02_principal_screen` | Layout Adaptativo | State-driven | MIENTRAS el usuario navegue en escritorio o móvil, el sistema DEBERÁ adaptar dinámicamente el layout elástico con Slivers y mapa reactivo. |
| `03_listas` | Favoritos y Listas | Event-driven | CUANDO el usuario agregue un inmueble a su lista, el sistema DEBERÁ actualizar la persistencia en CouchDB `buscobien_listas_propiedades`. |
| `07_routes` | Enrutamiento Nombrado | Ubicuo | El sistema DEBERÁ resolver las rutas web y móviles mediante `AppRoutes.routeGenerate` preservando URLs limpias sin fragmentos `#`. |
| `08_pantallas/inicio` | Búsqueda & Paginado | Event-driven | CUANDO el usuario desplace la lista, el sistema DEBERÁ consultar la API 10-en-10 mediante consultas Mango en `buscobien_propiedades`. |
| `08_pantallas/tu_cuenta` | Motor Social | Event-driven | CUANDO un usuario envíe una invitación de Conocido o Grupo, el sistema DEBERÁ registrar el token de invitación en `buscobien_invitaciones`. |
| `10_user_login` | Autenticación y JWT | Complex | MIENTRAS exista una sesión activa, CUANDO se emita una petición HTTP, el interceptor Dio DEBERÁ adjuntar el token JWT almacenado. |
| `14_geolocalizacion` | Google Maps & INE | Optional Feature | DONDE las coordenadas de GPS no estén disponibles, el sistema DEBERÁ realizar fallback a las coordenadas SEPOMEX del código postal. |
| `20_var_globales` | Estilos & M3 | Ubicuo | El sistema DEBERÁ consumir exclusivamente los tokens de color del `ColorScheme` de `appTheme` en `var_color_themes.dart`. |
| `40_security` | Almacenamiento Seguro | State-driven | MIENTRAS se ejecute en iOS/Android, el sistema DEBERÁ usar `flutter_secure_storage`; en Web/Windows DEBERÁ usar `shared_preferences`. |

---

## 3. Catálogo de Epics y Historias de Usuario

- **Epics EARS**: Ubicados en [`epics_ears/`](epics_ears/) (26 especificaciones por módulo).
- **User Stories**: Ubicadas en [`user_stories/`](user_stories/) (27 historias detalladas con criterios de aceptación).
