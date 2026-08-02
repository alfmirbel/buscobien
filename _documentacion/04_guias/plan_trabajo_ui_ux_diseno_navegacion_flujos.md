# Plan de Trabajo — Cumplimiento UI/UX y tokens M3
## Basado en: `auditoria_ui_ux_diseno_navegacion_flujos.md`

**Rol:** dev_engineer  
**Política de color/tokens:**
- Regla general: todo color/tamaño/tipografía debe pasar por `appTheme` o variables globales.
- Excepción permitida: solo cuando la interfaz requiera un color específico por marca/contraste técnico. En ese caso se usará `Colors` o `Color(0x...)` con comentario `// EXCEPCION_COLOR_ESPECIFICO: motivo`.

---

## Variables generales nuevas propuestas

| Variable | Valor sugerido | Uso objetivo |
|----------|----------------|--------------|
| `navBarHeight` | `56.0` | Altura estándar de `NavigationBar` en módulos sociales y global. |
| `socialAppBarHeight` | `40.0` | Altura de appBar secundaria usada en social y detalle. |
| `menuTabSmallLabelSize` | ya existe | Usar en tabs sociales con texto reducido. |
| `fontSizeChipFilter` | `11.0` | Chips/filtros si se normaliza en toda la app. |
| `colorDividerSocial` | `appTheme.outlineVariant` | Divisores en listas sociales, vía tema central. |
| `colorScaffoldSurface` | `appTheme.surface` | Fondo general de scaffolds evitando `onInverseSurface`. |

Nota: se mantienen las variables ya existentes (`fontSizeMenuBar`, `fontSizeTituloPagina`, etc.) y se reemplazan literales por estas constantes donde corresponda.

---

## Fase 0 — Reglas y excepciones

1. Crear `lib/20_var_globales/ui_exceptions.dart` con constantes “exception” y comentarios obligatorios.
2. Documentar la regla en `_documentacion/reglas_ui_excepciones.md`.
3. Establecer como estándar: si no está en `appTheme` ni en variables globales, no debe ir hardcodeado.

---

## Fase 1 — Tokens y tema central

Tareas:
1. `main.dart`
   - Remplazar `fontSize: 10` en `navigationBarTheme.labelTextStyle` por `fontSizeMenuBar`.
   - Asegurar selected/unselected usen misma variable.

2. `var_de_estilo_widgets.dart` / helpers
   - Evaluar unificar alturas de appBar secundarias con `socialAppBarHeight`.

3. `principal_sliver_screen_menus_inicio.dart`
   - Evitar render doble cuando `indiceInicial == 1`.
   - Opción A: render condicional del sliver inicial en Propiedades.
   - Opción B: wrapper común que aplique solo un sliver activo por contexto.

4. `MenuDrawer`
   - Validar items contra las 5 opciones actuales del Menú Inicial.
   - Eliminar rutas obsoletas y normalizar estilos por `appTheme`.

5. Código muerto
   - Resultado de verificación: `00_principales_opciones.dart` NO está muerto.
     Lo usan activamente `principal_00_inicio.dart` y al menos 8 vistas (`03_vistas`).
   - Acción ajustada: mantener el archivo y validar solo limpieza de comentarios/rutas obsoletas dentro de él en una fase posterior si se requiere.
---

## Fase 2 — Social (Conocidos/Grupos)

Tareas:
1. `conocidos_view.dart` / `grupos_view.dart`
   - Cambiar `height: 60` por `navBarHeight`.
   - Confirmar uso de `appTheme` para fondos y textos.

2. `PageInvitacionesGrupo`
   - Reemplazar `Theme.of(context).colorScheme` por `appTheme`.
   - Migrar literales tipográficas a variables globales.

3. `PageInvitaciones`
   - Idem: eliminar fugas de `Theme.of(...)` y hardcodeos.

4. `PageMisContactos` / `PageDescubrirUsuarios`
   - Aplicar variables `fontSizeTituloPagina`, `fontSizeSubtituloPagina`.
   - Estandarizar padding y borderRadius por variables de menú.

5. `page_chat_privado.dart`
   - Agregar timestamp estilo `page_chat_grupo.dart`.
   - Evaluar helper común para formato de hora.

6. `page_chat_grupo.dart`
   - Normalizar fondos: `Scaffold` -> `appTheme.surface`.
   - Evitar `onInverseSurface` como fondo general fuera de inversos reales.

---

## Fase 3 — Fondos y jerarquía M3

Tareas:
1. Revisión global de scaffolds/slivers que usan `appTheme.onInverseSurface` como fondo.
2. Reemplazar por `appTheme.surface` cuando corresponda.
3. Usar `onInverseSurface` solo en SnackBar, dialogs inversos o chips invertidos.

---

## Fase 4 — Responsividad y WASM/Desktop

Tareas:
1. `PaginaBuscaEspacios` y vistas críticas: incluir branching por ancho (`isMobile`, `isTablet`) para `NavigationRail` vs controles compactos.
2. Validar ausencia de errores `Unbounded width/height` en WASM.
3. Documentar breakpoints usados en `var_color_widget.dart` y su aplicación.

---

## Fase 5 — Notificaciones y feedback

Tareas:
1. Definir alcance mínimo: badge global en tab/página ¿o centro unificado?
2. Si se implementa badge global, crear provider/estado central y estilo por `appTheme`.
3. Si no, documentar decisión como excepción funcional y avanzar en siguiente release.

---

## Fase 6 — Verificación

Tareas:
1. `flutter analyze` tras cambios.
2. Build WASM para detectar errores de layout.
3. Ejecutar routeo por los 5 tabs y Motor Social completo.
4. Verificar ausencia de `Theme.of(context).colorScheme` residual con busqueda global.

---

## Orden sugerido de ejecución

1. Fase 0 → reglas.
2. Fase 1 → tokens y doble sliver.
3. Fase 2 → social (Conocidos/Grupos).
4. Fase 3 → fondos M3.
5. Fase 4 → responsividad.
6. Fase 5 → notificaciones.
7. Fase 6 → verificación.

---

*Generado por dev_engineer. Este plan es ejecutable; sus tareas se vuelcan a TODO antes de codificar.*
