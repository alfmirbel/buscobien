# Epic: Detección y Gestión de Conectividad (41_connectivity)

**Directorio:** `lib\41_connectivity\`  
**Archivos:** `connectivitycheck_provider.dart`, `pagina_sin_coneccion.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| App robusta offline-first | Usuario final | Ve estado de conexión en tiempo real; si pierde red, app guía a recuperarla | Proveedor reactivo `checaConeccionesProvider` + pantalla auto-retry |
| | Sistema | Bloquea navegación a secciones que requieren red (splash, búsquedas) | Gate de conectividad en splash y providers dependientes |

---

## User Story Mapping

```
App en ejecución
       │
       ▼
┌─────────────────────────────────────────┐
│ checaConeccionesProvider (AsyncNotifier)│
│ - Escucha connectivity_plus stream      │
│ - Estado: ElementoDeConeccion           │
│   (etiqueta: "Conectado"/"Sin conexión" │
│    + tipo: wifi/mobile/ethernet/none)   │
└──────────────┬──────────────────────────┘
               │
    ┌──────────┼──────────┐
    ▼          ▼          ▼
 Conectado  Cambio      Sin conexión
 (wifi/     de tipo     (auto navega
  mobile/   (rebuild)   a /sinconeccion)
  ethernet)
    │          │          │
    ▼          ▼          ▼
Permite    Actualiza   PaginaSinConeccion
navegación  UI badges   (Escucha provider →
a features  (iconos)    pop() al reconectar)
requeridas
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-CONN-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-CONN-001 | **Ubicuo** | El sistema expondrá `checaConeccionesProvider` (AsyncNotifierProvider<ElementoDeConeccion>) que emite estado de conectividad reactivo. | `lib\41_connectivity\connectivitycheck_provider.dart:80` | En código |
| REQ-CONN-002 | **Ubicuo** | El sistema definirá `ElementoDeConeccion` con: `index`, `etiqueta` (String), `icono` (IconData), `boolEstadoConeccion[7]` (flags por tipo), `estadoDeLaConeccion` (bool general). | `connectivitycheck_provider.dart:10-20` | En código |
| REQ-CONN-003 | **Evento** | Cuando `connectivity_plus` emita `onConnectivityChanged(List<ConnectivityResult>)`, el sistema ejecutará `_logicaAsignaConectividad` que mapea cada `ConnectivityResult` a etiqueta/icono/flags y actualiza estado inmutable. | `connectivitycheck_provider.dart:55-78` | En código |
| REQ-CONN-004 | **Evento** | Cuando el estado cambie a **"Conectado"** (wifi/mobile/ethernet/vpn/bluetooth), el sistema seteará `rutaConectividad = "/principal"`. | `connectivitycheck_provider.dart:65-70` | En código |
| REQ-CONN-005 | **Evento** | Cuando el estado cambie a **"Sin conexión"** (`ConnectivityResult.none`), el sistema seteará `rutaConectividad = "/sinconeccion"`. | `connectivitycheck_provider.dart:72-75` | En código |
| REQ-CONN-006 | **Estado** | Mientras la app esté en **splash**, el sistema **no** navegará a principal hasta que `checaConeccionesProvider` emita "Conectado" Y timer 3s completado. | `lib\01_splash_screen\splash_page.dart:60-68` | En código |
| REQ-CONN-007 | **Estado** | Mientras la app esté en **pantalla de error** (`PaginaSinConeccion`), el sistema escuchará `checaConeccionesProvider` vía `ref.listen` y al detectar "Conectado" hará `Navigator.pop()` automático. | `lib\41_connectivity\pagina_sin_coneccion.dart:25-30` | En código |
| REQ-CONN-008 | **No Deseado** | Si `connectivity_plus` falla al iniciar (permiso denegado, error nativo), el sistema atrapará la excepción en `initConnectivity()` y mantendrá estado previo (sin crash). | `connectivitycheck_provider.dart:45-50` try-catch | En código |
| REQ-CONN-009 | **Complejo** | Mientras la app esté en foreground, cuando ocurra transición `wifi → mobile → none → wifi`, el sistema actualizará `ElementoDeConeccion` en cada paso y notificará a todos los `ref.watch` (UI badges, gates de navegación, splash). | `connectivitycheck_provider.dart:55-78` switch | En código |
| REQ-CONN-010 | **Ubicuo** | El sistema expondrá variable global `rutaConectividad` (String) como ruta destino actual según conectividad ("/principal" o "/sinconeccion"). | `connectivitycheck_provider.dart:30` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `ElementoDeConeccion` model | `connectivitycheck_provider.dart` | 10-20 |
| `ChecaConeccionesNotifier` (AsyncNotifier) | `connectivitycheck_provider.dart` | 22-95 |
| `build()` + stream subscription | `connectivitycheck_provider.dart` | 25-40 |
| `_logicaAsignaConectividad` (switch mapping) | `connectivitycheck_provider.dart` | 55-78 |
| `rutaConectividad` global | `connectivitycheck_provider.dart` | 30 |
| `PaginaChecaInternet` (widget demo) | `connectivitycheck_provider.dart` | 97-130 |
| `PaginaSinConeccion` (auto-retry) | `pagina_sin_coneccion.dart` | 1-50 |

---

## Notas de Arquitectura

- **connectivity_plus**: Package oficial Flutter para conectividad multiplataforma.
- **AsyncNotifier pattern**: Estado inmutable reactivo (`AsyncValue<ElementoDeConeccion>`).
- **9 tipos de conexión mapeados**: wifi, mobile, ethernet, vpn, bluetooth, other, none, unknown, none (duplicado en lista).
- **Variable global `rutaConectividad`**: Acoplamiento temporal — ideal mover a provider computed.
- **Auto-retry UX**: `PaginaSinConeccion` se cierra sola al recuperar red — sin acción usuario.