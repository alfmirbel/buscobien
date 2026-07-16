import 'dart:ui';

// ============================================================================
// Reglas de excepción UI — BuscoBien
// ============================================================================
//
// REGLA GENERAL:
//   No usar colores tipográficos/estilos directamente con literales
//   (Colors..., Color(0xFF...), TextStyle(fontSize: ..., color: ...)).
//   Todo debe pasar por:
//     - appTheme (var_color_themes.dart)
//     - variables globales (variables_globales.dart / var_menus.dart)
//     - widgets helpers reutilizables (var_de_estilo_widgets.dart)
//
// EXCEPCIÓN PERMITIDA:
//   Solo cuando la interfaz requiere un color/tamaño específico por:
//     - marca o contraste técnico indispensable
//     - elemento visual que no puede mapearse al tema sin perder semántica
//   En ese caso se permite Colors / Color(0xFF...) con comentario obligatorio:
//     // EXCEPCION_COLOR_ESPECIFICO: motivo
//     // ARCHIVO: ruta relativa del archivo
//     // FECHA: YYYY-MM-DD
//
// No se admiten excepciones ad-hoc. Deben registrarse aquí.
//
// ============================================================================
// Catálogo de excepciones aceptadas
// ============================================================================
//
// 1. Color primario de la marca institucional en iconos de login
//    Motivo: no es color de estado M3, es branding.
//    Uso: var_login.dart
//
// 2. Tonos específicos en snapshot/debug visual
//    Motivo: diferenciación técnica temporal hasta refactor completo.
//    Uso: cobro/depósito screens.
//
// ============================================================================
// Paleta de excepciones por dominio
// ============================================================================
//
// EXCEPCION_COLOR_ESPECIFICO: marca institucional en botones de login
// ARCHIVO: lib/20_var_globales/var_login.dart
// FECHA: 2026-07-13
const Color loginPrimaryBrand = Color(0xFF415AA9);
