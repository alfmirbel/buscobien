# Alineación SDD -> EARS/BDD
**Fecha:** 2026-07-25  
**Propósito:** Mapear cada documento SDD generado para `lib/` con los requerimientos EARS y BDD existentes.

---

## Mapa de alineación

| SDD | EARS | BDD | Observaciones |
|---|---|---|---|
| `08_pantallas_inicio.md` | REQ-06.001, REQ-06.002, REQ-06.003, REQ-06.004, REQ-06.005, REQ-06.008, REQ-06.009 | REQ-TAB-001 | Incluye PDF export y filtros |
| `08_pantallas_perfil.md` | REQ-14.001, REQ-14.002, REQ-14.003, REQ-14.004, REQ-14.005 | — | Avatar y preferencias |
| `08_pantallas_propiedades.md` | REQ-06.006, REQ-06.007 | REQ-TAB-001 | PDF export confirmado |
| `08_pantallas_ubicacion.md` | REQ-08.001, REQ-08.002, REQ-08.003, REQ-08.004, REQ-08.005, REQ-08.006 | REQ-LOC-001 | SEPOMEX + GMaps |
| `08_pantallas_widgets_comunes.md` | REQ-16.001, REQ-16.002, REQ-16.003, REQ-16.004, REQ-16.001 | REQ-THEME-001 | M3 tokens |
| `08_pantallas_tu_cuenta_tus_espacios.md` | REQ-12.001, REQ-12.002, REQ-12.003, REQ-12.006 | REQ-SOC-003 | CRUD + tipos condicionales |
| `08_pantallas_tu_cuenta_compra_espacios.md` | REQ-12.004, REQ-12.005 | REQ-COMP-001 | Compra + totales |
| `08_pantallas_tu_cuenta_grupos.md` | REQ-10.001, REQ-10.002, REQ-10.003, REQ-10.004, REQ-10.005, REQ-10.006, REQ-10.007, REQ-10.008 | REQ-SOC-002 | Chat continuo; _rev |
| `08_pantallas_tu_cuenta_conocidos.md` | REQ-11.001, REQ-11.002, REQ-11.003, REQ-11.004, REQ-11.005 | REQ-SOC-001 | Contactos + chat |
| `10_user_login.md` | REQ-05.001, REQ-05.002, REQ-05.003, REQ-05.004, REQ-05.005, REQ-05.006, REQ-05.007, REQ-05.008, REQ-05.009 | REQ-AUTH-001/002/003/004 | Sesión + avatar |
| `22_imagenes.md` | REQ-13.001, REQ-13.002, REQ-13.003, REQ-13.004, REQ-13.005, REQ-13.006, REQ-13.007, REQ-13.008 | REQ-MED-001 | Fotos + avatar |
| `40_security.md` | REQ-15.004 | REQ-BCK-001 | Endpoints + sanitización |
| `41_connectivity.md` | REQ-15.001, REQ-15.002, REQ-15.006 | REQ-CON-001 | Online/offline |
| `42_sistema_operativo.md` | REQ-15.003 | — | Plataforma host |
| `60_global_widgets.md` | REQ-16.001, REQ-16.002, REQ-16.003, REQ-16.004, REQ-16.005 | REQ-THEME-001 | Diálogos + debug |

## Brechas alineadas
- `08_pantallas/inicio`: cubre EARS `REQ-06.*` y BDD `REQ-TAB-001`.
- `08_pantallas/propiedades`: cubre EARS `REQ-06.006/06.007` y PDF.
- `tu_cuenta/grupos`: cubre EARS `REQ-10.*` y BDD `REQ-SOC-002`.
- `tu_cuenta/conocidos`: cubre EARS `REQ-11.*` y BDD `REQ-SOC-001`.
- `tu_cuenta/tus_espacios` y `compra_espacios`: cubren EARS `REQ-12.*`, BDD `REQ-SOC-003` y `REQ-COMP-001`.
- `22_imagenes`: cubre EARS `REQ-13.*` y BDD `REQ-MED-001`.
