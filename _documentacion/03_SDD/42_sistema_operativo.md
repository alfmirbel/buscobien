# SDD - 42_sistema_operativo
**Directorio:** `lib/42_sistema_operativo`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `detecta_os.dart`
- **Providers:** `checaPlataformaProvider`
- **Modelos:** `ElementoDeConeccion` extendido con etiqueta de plataforma
- **Páginas/Rutas:** `/plataforma -> PaginaDetectaPlataforma`
- **I/O externo:** No
- **Dependencias:** `flutter_riverpod`
- **Riesgos:** Plaforma web puede requerir ajustes adicionales para permisos.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá detectar la plataforma host y exponerla al resto de la app.

### REQ-UBI-002 — Ubiquitous
El sistema deberá mapear `kIsWeb`, Android, iOS, Windows, Linux, macOS.

### REQ-EVT-001 — Event-Driven
Cuando Splash monta, el sistema deberá asignar `checaPlataformaProvider` en post-frame.

### REQ-OPT-001 — Optional Feature
Donde la plataforma sea web, el sistema deberá ajustar bounds del mapa y storage.
