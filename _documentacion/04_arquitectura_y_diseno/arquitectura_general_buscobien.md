# Arquitectura General de la Aplicación BuscoBien

## Visión General

BuscoBien es una aplicación móvil multiplataforma desarrollada con Flutter para la promoción inmobiliaria en México. La aplicación sigue una arquitectura modular y escalable que separa claramente las responsabilidades entre presentación, lógica de negocio y acceso a datos.

### Principios Arquitectónicos

1. **Separación de Responsabilidades**: La UI está completamente desacoplada de la lógica de negocio
2. **Gestión de Estado**: Utiliza Riverpod 3.x para un manejo predecible del estado
3. **Inmutabilidad**: Los modelos de datos utilizan Freezed para garantizar inmutabilidad
4. **Testing Friendly**: Arquitectura diseñada para facilitar pruebas unitarias y de widgets
5. **Escalabilidad**: Estructura modular que permite añadir nuevas funcionalidades sin afectar las existentes

## Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── 01_home/                     # Módulo home
├── 01_splash_screen/            # Pantalla de presentación
├── 02_principal_screen/         # Pantalla principal
├── 03_listas/                   # Módulo de listas
├── 03_vistas/                   # Vistas auxiliares
├── 04_provider/                 # Proveedores de configuración
├── 05_provider_menus/           # Proveedores de menús
├── 07_routes/                   # Sistema de navegación
├── 08_pantallas/                # Pantallas principales de la aplicación
│   ├── inicio/                  # Pantalla de inicio/búsqueda
│   ├── perfil/                  # Perfil de usuario
│   ├── propiedades/             # Detalle de propiedades
│   ├── tu_cuenta/               # Gestión de cuenta
│   │   ├── conocidos/           # Módulo de contactos
│   │   ├── grupos/              # Módulo de grupos
│   │   └── tus_espacios/        # Gestión de propiedades del usuario
│   └── widgets_comunes/         # Widgets reutilizables
├── 10_user_login/               # Sistema de autenticación
│   ├── avatar/                  # Gestión de avatares
│   ├── data_models/             # Modelos de datos de usuario
│   └── usuario_login/           # Flujo de login/registro
├── 12_localidades_user/         # Gestión de localidades por usuario
├── 14_geolocalizacion/          # Integración con Google Maps
├── 20_var_globales/             # Variables globales y temas
├── 22_imagenes/                 # Gestión de imágenes
├── 40_security/                 # Seguridad y autenticación
├── 41_connectivity/             # Manejo de conectividad
├── 42_sistema_operativo/        # Detección de sistema operativo
└── 60_global_widgets/           # Widgets globales reutilizables
```

## Capas de la Arquitectura

### 1. Capa de Presentación (UI)

Ubicada principalmente en:
- `lib/08_pantallas/` - Pantallas principales de la aplicación
- `lib/60_global_widgets/` - Widgets reutilizables globales
- `lib/01_splash_screen/`, `lib/02_principal_screen/` - Pantallas específicas

**Características:**
- Widgets "tontos" (dumb widgets) sin lógica de negocio
- Utiliza Material 3 con componentes como `NavigationBar`, `FilledButton`
- Temas centralizados en `lib/20_var_globales/var_color_themes.dart`
- Responsive design para diferentes tamaños de pantalla

### 2. Capa de Gestión de Estado

Implementada con **Riverpod 3.x**:
- Proveedores en directorios específicos según funcionalidad
- Generación automática con `riverpod_generator`
- Estado inmutable mediante Freezed
- Separación de estado de UI y estado de aplicación

**Ejemplos de proveedores:**
- `lib/01_home/home_navigation_provider.dart` - Estado de navegación del home
- `lib/04_provider/pagina_colores.dart` - Estado de temas/colores
- `lib/14_geolocalizacion/provider_actual_place.dart` - Estado de ubicación actual
- `lib/41_connectivity/connectivitycheck_provider.dart` - Estado de conectividad

### 3. Capa de Modelo de Dominio

Modelos de datos utilizando:
- **Freezed** para clases inmutables y pattern matching
- **json_serializable** para (de)serialización JSON
- Archivos generados: `*.freezed.dart` y `*.g.dart`

**Ubicación típica:**
- Dentro de cada módulo funcional (ej: `lib/08_pantallas/inicio/data_espacios_casas.dart`)
- `lib/routes_parameters.dart` - Parámetros de navegación tipados

### 4. Capa de Servicio y Comunicación

- **Dio** para comunicación HTTP con el backend
- Interceptors para manejo automático de JWT
- Servicios especializados por dominio

**Servicios identificados:**
- Servicios de propiedades (búsqueda, filtrado, detalle)
- Servicios de usuario (autenticación, perfil)
- Servicios de imágenes (subida, descarga, gestión)
- Servicios de mapas y geolocalización
- Servicios de conectividad

### 5. Capa de Navegación

Sistema de navegación personalizado basado en:
- `lib/07_routes/app_routes.dart` - Definición de rutas centralizada
- `lib/07_routes/routes_parameters.dart` - Tipado seguro de parámetros
- `onGenerateRoute` en MaterialApp para rutas dinámicas
- Manejo de deep links mediante `deep_link_handler.dart`

### 6. Capa de Seguridad

Implementada en `lib/40_security/`:
- Manejo de tokens JWT
- Almacenamiento seguro credenciales (`flutter_secure_storage` para móvil, `shared_preferences` para web/Windows)
- Encriptación de datos sensibles
- Validación de entradas

### 7. Capa de Utilidades Globales

- `lib/20_var_globales/` - Variables globales, temas, constantes
- `lib/60_global_widgets/` - Widgets reutilizables (debugprint, dialogs, formatters)
- Funciones auxiliares distribuidas según contexto

## Flujo de Datos

```
UI Layer ←→ State Management Layer (Riverpod) ←→ Domain Models ←→ Service Layer ←→ Backend API
```

### Ejemplo de Flujo (Búsqueda de Propiedades):

1. Usuario ingresa criterios de búsqueda en UI (`lib/08_pantallas/inicio/pagina_inicio_busca_espacios.dart`)
2. Estado actualizado en proveedor correspondiente (`inicio_propiedades_providers.dart`)
3. Servicio llama a API mediante Dio con parámetros de búsqueda
4. Respuesta JSON deserializada a modelos Freezed (`data_espacios_casas.dart`)
5. Estado actualizado notifica a UI para reconstrucción
6. UI muestra resultados utilizando widgets especializados (`widget_wrap_modern_card.dart`)

## Integración con Backend

> **Estado real verificado en `lib/` (2026-10-07).** El cliente Flutter **sí se conecta directamente a CouchDB**: 34 archivos usan `direccionip` (`COUCHDB_URL`) con cabecera `Authorization: Basic` construida con `username:password` (`COUCHDB_USER`/`COUCHDB_PASSWORD`, inyectados con `--dart-define`), mediante el paquete `http` (32 archivos). `dio` está declarado en `pubspec.yaml` pero **no se importa en ningún archivo**; no hay interceptor JWT (`jwtToken` existe en `AuthState`, pero no se obtiene de ningún servicio). El login consulta vistas de `buscobien_usuarios` y compara el hash SHA-256 en el cliente. El único servicio propio es el microservicio de correo `server/buscobien-mailer` (puerto 3001). La arquitectura *Flutter → API Node.js → CouchDB* descrita a continuación es el **objetivo**, no la situación actual, y las credenciales compiladas en la app son un riesgo de seguridad crítico.

### Situación actual

**Flutter App → (HTTP + Basic Auth) → CouchDB**, más **Flutter App → buscobien-mailer** (correo de recuperación de contraseña).

- Cliente HTTP real: paquete `http` (`dio` sin uso).
- Sesión: se guarda en `SessionStorage` (`flutter_secure_storage` en Android, iOS y Windows; `shared_preferences` solo en Web).
- Endpoints de bases y vistas CouchDB definidos en cada repositorio/provider y en `40_security/urls_endpoints_espacios.dart`.

### Arquitectura objetivo (pendiente)

**Flutter App → Node.js API (repositorio separado) → CouchDB**, con JWT, `Dio` con interceptor, y credenciales de CouchDB solo en el servidor. Hasta migrar, ningún documento debe afirmar que el cliente no toca CouchDB.

## Tecnologías Clave

- **Flutter SDK** - Framework UI multiplataforma
- **Riverpod 3.x** - Gestión de estado reactiva
- **Freezed + json_serializable** - Modelos de datos inmutables
- **http** - Cliente HTTP en uso (`dio` declarado en `pubspec.yaml`, sin uso en el código)
- **flutter_secure_storage / shared_preferences** - Almacenamiento seguro
- **google_maps_flutter** - Integración con mapas
- **url_strategy** - Estrategia de URLs limpias para web
- **build_runner** - Generación de código automática

## Patrones de Diseño Utilizados

1. **Provider Pattern** - Para inyección de dependencias y gestión de estado
2. **Repository Pattern** - Abstracción de fuentes de datos
3. **DTO Pattern** - Transferencia de datos entre capas
4. **Singleton** - Para servicios compartidos (a través de providers)
5. **Factory** - Para creación de widgets complejos
6. **Observer** - Actualización reactiva de UI mediante providers

## Manejo de Plataformas

- **Estrategia común**: La mayoría del código es multiplataforma
- **Especificidades platform**: 
  - `lib/42_sistema_operativo/detecta_os.dart` - Detección de SO
  - Implementaciones específicas en `web/`, `windows/`, `android/`, `ios/`
  - Almacenamiento: `flutter_secure_storage` (móvil) vs `shared_preferences` (web/Windows)

## Proceso de Generación de Código

Después de modificar modelos Freezed o annotations de Riverpod:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Genera automáticamente:
- `*.freezed.dart` - Implementaciones Freezed
- `*.g.dart` - Serialización JSON
- `*.g.dart` para riverpod_provider - Proveedores de estado

## Consideraciones de Rendimiento

1. **Lazy Loading**: Pantallas cargadas bajo demanda mediante navegación
2. **Cache de Imágenes**: Uso eficiente de `CachedNetworkImage` donde aplica
3. **Estado Minimalista**: Solo se almacena en estado lo necesario para UI
4. **Disposición Eficiente**: Uso de `ListView.builder`, `SliverList` para listas largas
5. **Separación de Cargas Pesadas**: Operaciones de cómputo en isolates cuando es necesario

## Seguridad

1. **Almacenamiento de Credenciales**: Nunca en texto plano
2. **Tokens JWT**: pendiente (el cliente usa Basic Auth con credenciales compiladas; ver «Integración con Backend»)
3. **Validación de Entradas**: En capa de presentación y servicios
4. **Comunicación Segura**: HTTPS obligatorio para todas las llamadas API
5. **Protección CSRF**: no aplica al cliente actual; depende del backend objetivo

## Escalabilidad

La arquitectura permite:
- Añadir nuevos módulos sin modificar código existente
- Reemplazar implementaciones de servicios sin afectar UI
- Escalar equipos de desarrollo trabajando en módulos independientes
- Añadir nuevas plataformas con mínimo impacto
- Integrar nuevos servicios de terceros mediante providers

## Pruebas

- **Tests de Unidad**: Servicios y lógica de negocio
- **Tests de Widgets**: Componentes UI aislados
- **Tests de Integración**: Flujos completos de usuario (limitado actualmente)
- **Archivo de prueba existente**: `test/widget_test.dart` (smoke test)

## Documentación y Mantenimiento

- Documentación técnica en `_documentacion/`
- Comentarios significativos en código complejo
- Estructura consistente para facilitar onboarding
- Nombres descriptivos y convenciones de código seguidas

## Conclusión

La arquitectura de BuscoBien sigue las mejores prácticas de desarrollo Flutter moderno, priorizando:
- Mantenibilidad mediante separación clara de capas
- Escalabilidad para crecimiento futuro
- Robustez a través de inmutabilidad y manejo explícito de errores
- Experiencia de usuario consistente en todas las plataformas
- Facilidad de testing para asegurar calidad

Esta estructura ha demostrado ser efectiva para el desarrollo continuo de la aplicación, permitiendo adicionar funcionalidades complejas manteniendo la estabilidad del sistema existente.