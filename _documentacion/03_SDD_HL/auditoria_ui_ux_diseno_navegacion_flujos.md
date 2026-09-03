# Auditoría UI/UX — BuscoBien
## Cumplimiento de diseño M3, navegación y flujos de trabajo

**Rol:** ui_specialist  
**Alcance:** Flujo principal (Splash → Menús → Propiedades / Ubicación / Mi Cuenta / Perfil), módulos Conocidos y Grupos (Motor Social), Login/Sesión y uso de tema/estilos.  
**Fuentes de verdad:** `antigravity_ui_rules.md`, `arquitectura_navegacion.md`, `flujo_operacion_buscobien.md`, `Buscobien_SDD.md`, `TuCuenta_SDD.md`, documentos de `diseno_motor_social/`.  
**No se modificó código ni archivos existentes.**

---

## Resumen ejecutivo

La navegación del Menú Inicial y la mayor parte del flujo de operación cumplen con la reorganización documentada: Inicio, Propiedades, Ubicación, Mi Cuenta y Perfil. El Motor Social está implementado para Conocidos y Grupos, con pantallas de descubrimiento, invitaciones, contactos, detalle y chat. No obstante, se detectan desviaciones relevantes en tipografía/tokens M3, composición duplicada de slivers, consumo mixto de `appTheme` vs `Theme.of(context)`, hardcodeos de tamaños en `NavigationBar`, y ausencias funcionales frente al diseño base de notificaciones/feedback.

---

## Hallazgos

### H1. Doble sliver appbar bajo Propiedades
- **Dónde:** `principal_sliver_screen_menus_inicio.dart`, bloque `indiceInicial == 1`.
- **Qué pasa:** `menuSuperiorMenuInicial(ref)` se renderiza siempre; al entrar a Propiedades se suma `menuSuperiorMenuPrincipal(ref)`. Quedan dos barras de tabs visibles en la misma página.
- **Requerimiento:** Menú Inicial siempre visible; submenús de Propiedades solo cuando corresponde.
- **Cumplimiento:** Parcial. No rompe navegación, pero diluye la jerarquía visual y puede confundir en WASM/escritorio.

### H2. Hardcodeo de fontSize en NavigationBar global
- **Dónde:** `main.dart`, `navigationBarTheme.labelTextStyle`.
- **Qué pasa:** Usa `fontSize: 10` literal tanto para selected como unselected.
- **Requerimiento:** `antigravity_ui_rules.md` exige `fontSizeMenuBar` y variables globales en NavigationBar.
- **Cumplimiento:** No cumple. Además, la regla pide ≥12; aquí es 10.

### H3. Uso mixto de `appTheme` vs `Theme.of(context).colorScheme`
- **Dónde:** `PageInvitacionesGrupo` (`cs.outlineVariant`, `cs.onSurfaceVariant`), entre otras vistas.
- **Qué pasa:** Se consulta `Theme.of(context).colorScheme` en vez de `appTheme` central.
- **Requerimiento:** Uso exclusivo de `appTheme` para colores.
- **Cumplimiento:** Parcial. Hay páginas alineadas y otras con fugas.

### H4. Hardcodeos tipográficos en vistas de Motor Social
- **Dónde:** `PageDescubrirUsuarios`, `PageInvitaciones`, algunas pantallas de social.
- **Qué pasa:** `fontSize: 14`, `fontSize: 11`, `fontSize: 13` en títulos, tabs o estados.
- **Requerimiento:** Tipografía por variables globales (`fontSizeTituloPagina`, `fontSizeSubtituloPagina`, `fontSizeDialogTitulo`, `fontSizeDialogCampo`, etc.).
- **Cumplimiento:** Parcial. Algunas pantallas usan variables; otras tienen literales.

### H5. `NavigationBar` hardcodeada en altura en Conocidos/Grupos
- **Dónde:** `conocidos_view.dart`, `grupos_view.dart`.
- **Qué pasa:** `height: 60` fijo.
- **Requerimiento:** `antigravity_ui_rules.md` indica usar tokens/variables globales y mantener consistencia M3.
- **Cumplimiento:** No cumple. Altura debería derivarse de tema o variable reutilizable.

### H6. Estado/lecturas en vistas sin `ConsumerWidget` cuando usan Riverpod
- **Dónde:** `ConocidosView` es `StatefulWidget` con `setState`, pese a usar Riverpod indirecto; `GruposView` es `ConsumerStatefulWidget`.
- **Qué pasa:** Patrón mixto de consumo de estado.
- **Requerimiento:** Vistas “dumb” basadas en Riverpod; evitar lógica/estado local innecesario.
- **Cumplimiento:** Parcial. No es incorrecto, pero reduce uniformidad.

### H7. Navegación faltante por plataforma (WASM/Desktop)
- **Dónde:** `PaginaBuscaEspacios` usa `NavigationRail` siempre dentro de un `Row`.
- **Qué pasa:** No hay ramificación por `kIsWeb`/Windows; en móvil puede forzar layout horizontal cuando debería comportarse como rail solo en ancho amplio.
- **Requerimiento:** Responsividad WASM/escritorio clara sin “Unbounded width/height” y adaptación por tamaño.
- **Cumplimiento:** Parcial. Cumple slivers/listas, pero no evidencia adaptación condicional.

### H8. Ausencia de indicadores de notificaciones nuevas y centro de notificaciones
- **Dónde:** Módulos Conocidos/Grupos y documentación “Notificaciones entre usuarios...”.
- **Qué pasa:** No existe Campana/centro de notificaciones global ni contador unificado; solo tabs y SnackBars.
- **Requerimiento:** Mejores prácticas de UX piden indicador visual de solicitudes nuevas y reducción de ruido.
- **Cumplimiento:** No cumple. Falta el contador/indicador global más allá de badge en Grupos.

### H9. Drawer siempre presente sin verificación de contenido alineado a nueva navegación
- **Dónde:** `principal_sliver_screen_menus_inicio.dart` (`drawer: const MenuDrawer()`).
- **Qué pasa:** Drawer se mantiene, pero no se validó su contenido contra las nuevas opciones del Menú Inicial.
- **Requerimiento:** Navegación consistente entre drawer, sliver y tabs.
- **Cumplimiento:** Parcial/Riesgo. Puede haber rutas obsoletas en drawer tras reorganización.

### H10. Código muerto residual post-reorganización
- **Dónde:** `02_principal_screen/00_principales_opciones.dart` documentado como eliminado, pero sigue importado en `principal_sliver_screen_menus_inicio.dart`.
- **Qué pasa:** Import huérfano/genera dependencia innecesaria.
- **Requerimiento:** Limpieza técnica tras cambios de arquitectura.
- **Cumplimiento:** No cumple.

### H11. Chat privado sin helper de timestamp/hora consistente
- **Dónde:** `page_chat_privado.dart`.
- **Qué pasa:** No incluye timestamp visible; en chat grupal sí se usa `h:mm`.
- **Requerimiento:** Consistencia entre chats, con fecha/hora contextual.
- **Cumplimiento:** Parcial. Riesgo de confusión al identificar secuencia.

### H12. Inconsistencia en fondos vs roles M3
- **Dónde:** Varias pantallas usan `appTheme.onInverseSurface` como fondo general de `Scaffold`/`SliverFillRemaining`.
- **Qué pasa:** Se carga inversa como fondo de pantalla completa, afectando jerarquía surface/primary/secondary.
- **Requerimiento:** Jerarquía M3 respetada: `surface` como fondo, `onInverseSurface` para SnackBar/fondos inversos.
- **Cumplimiento:** No cumple parcialmente. Patrón generalizado pero técnicamente desviado.

---

## Observaciones

1. **Flujo principal alineado a documento:** Splash, conectividad, redirección a `PrincipalSliversMenuInicial`, tabs y ruteo por `indiceInicial` están implementados según `flujo_operacion_buscobien.md`.
2. **Requisito de login vía dialogBox:** se cumple en `_vistaSinUsuario` para Mi Cuenta y localidades no autenticadas.
3. **Motor Social:** estructura de tabs Contactos/Invitaciones/Descubrir implementada para conocidos y grupos; carga reactiva y providers separados existen.
4. **Integración de sesión:** al regresar a la app se restaura sesión y datos de usuario; alinea comportamiento esperado.
5. **Compilación WASM:** no se verifica build real en este análisis; solo se observa ausencia de branching explícito por plataforma en vistas clave.
6. **Hardcodeos de color/estilo concentrados en vistas rápidas:** problema mitigable si se refactorizan tokens por variable global.

---

## Recomendaciones

| ID | Tema | Acción propuesta |
|----|------|------------------|
| R-1 | Slivers dobles | Renderizar `menuSuperiorMenuInicial` solo cuando `indiceInicial != 1`, o bien ocultar visualmente el primer sliver en Propiedades para evitar dos tabs activos. |
| R-2 | Tipografía nav global | Sustituir `fontSize: 10` por `fontSizeMenuBar` o variable global y validar contraste M3. |
| R-3 | Consumo de color | Reemplazar lecturas `Theme.of(context).colorScheme` por `appTheme` en todas las pantallas; establecer lint para detectar fugas. |
| R-4 | Hardcodeos tipográficos | Migrar literales en vistas sociales a variables globales documentadas (`fontSizeTituloPagina`, `fontSizeDialogCampo`, etc.). |
| R-5 | NavigationBar altura | Definir altura en variable global/theme y aplicarla en Conocidos y Grupos. |
| R-6 | Drawer post-reorg | Validar contenido de `MenuDrawer` contra las 5 opciones nuevas; eliminar entradas antiguas. |
| R-7 | Código muerto | Remover import `00_principales_opciones.dart` si ya no se usa; verificar referencias. |
| R-8 | Chats y timestamps | Unificar helper de hora/fecha en `page_chat_privado.dart` como en `page_chat_grupo.dart`. |
| R-9 | Responsividad por plataforma | Introducir wrapper de ancho/plataforma en `PaginaBuscaEspacios` y vistas críticas para decidir `NavigationRail` vs controles compactos en móvil. |
| R-10 | Notificaciones globales | Evaluar badge/indicador global además del badge de Grupos; considera un centro de notificaciones unificado. |
| R-11 | Fondos y roles M3 | Cambiar `Scaffold`/slivers comunes a `appTheme.surface` cuando aplique; reservar `onInverseSurface` para inversos reales. |
| R-12 | Guía de estilos pantalla social | Establecer template de appBar/tabBar social homogéneo (igual altura, tamaño tipográfico, color primario) reutilizable. |

---

## Cumplimiento resumido

| Área | Cumplimiento | Evidencia |
|------|--------------|-----------|
| Reorganización de menús | Parcial | Providers y widgets reflejan 5 items iniciales y 4 items principales. |
| Navegación por índices | Cumple | `homeNavigationProvider` mueve `indiceInicial`/`indicePrincipal`. |
| Flujo Splash → Principal | Cumple | Rutas/timers/connectivity coherentes con documento. |
| Login anónimo → dialogBox | Cumple | `_vistaSinUsuario` abre dialog de login. |
| Motor Social: Conocidos | Parcial | Tabs y flujos existen; faltan contadores/feedback globales. |
| Motor Social: Grupos | Parcial | Estructura completa; alta directa/mejoras UX pendientes. |
| ThemeData M3 y tokens | Parcial | `appTheme` mayormente respetado; hay fugas y hardcodeos. |
| Tipografía por variables | Parcial | Se usan varias variables; hay literales recurrentes. |
| Responsividad WASM/Desktop | Parcial | Uso de slivers y scrolls; sin branching explícito por plataforma en vistas clave. |
| Drawer integrado a nueva navegación | Riesgo | Drawer presente pero contenido no auditado frente a reorganización. |

---

*Documento generado por ui_specialist. No se modificó código ni archivos del proyecto.*
