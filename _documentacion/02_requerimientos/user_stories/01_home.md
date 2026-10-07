# User Stories — Estado Navegación Home (01_home)

**Directorio:** `lib/01_home/`  
**Fecha:** 2026-08-12

---

## US-HOME-001: Navegación Global con 7 Dimensiones Independientes

**Card:**  
Como **usuario navegando entre secciones**  
Quiero **que mi posición en cada menú (Inicio, Principal, Gobierno, Espacio, Transacción, Mi Cuenta, Usuario) persista**  
Para **no perder contexto al cambiar de sección**

**Conversation:**  
`HomeState` (@freezed) almacena 7 índices `int` + `version`. `HomeNavigation` (@riverpod Notifier) expone `actualizarX(index)` (copyWith + version++) y `setX(index)` (copyWith sin version++). UI usa `ref.watch(homeNavigationProvider.select((s) => s.version))` para rebuild granular solo cuando `version` cambia. Log level 10 en cada `actualizarX`.

**Confirmation:**
- [ ] Cambiar tab Inicial → `actualizarInicial` → version++ → rebuild selectivo
- [ ] Cambiar tab Principal → `actualizarPrincipal` → version++ 
- [ ] Sincronización interna (setX) → NO incrementa version
- [ ] 7 dimensiones independientes: indices no se afectan entre sí
- [ ] Estado inicial: todos 0, version 0

---

## US-HOME-002: Versioning para Rebuild Granular

**Card:**  
Como **desarrollador optimizando performance**  
Quiero **que solo widgets interesados reconstruyan al cambiar navegación**  
Para **evitar rebuilds innecesarios en árbol completo**

**Conversation:**  
Patrón: `ref.watch(homeNavigationProvider.select((s) => s.version))` en widgets que necesitan reaccionar a CUALQUIER cambio de navegación. Widgets específicos usan `select((s) => s.indicePrincipal)` etc. `version` incrementa solo en `actualizarX` (acciones usuario), no en `setX` (sync interno).

**Confirmation:**
- [ ] Widget A escuchando `version` reconstruye al tocar cualquier tab
- [ ] Widget B escuchando `indicePrincipal` SOLO reconstruye al cambiar Principal
- [ ] `setPrincipal(2)` NO dispara rebuild de Widget A
- [ ] `actualizarPrincipal(2)` SÍ dispara rebuild de Widget A y B