# Inventario de Componentes - Sección `widgets_comunes` (D:\buscobien\lib\08_pantallas\widgets_comunes)

Este módulo contiene componentes visuales reutilizables compartidos por distintas pantallas de la interfaz, diseñados para estandarizar la presentación de datos críticos como tipos de transacción y precios de las propiedades de manera unificada.

---

## Tabla de Inventario de Componentes Compartidos

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales/Riverpod) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | `widget_letrero_tipo_transaccion.dart` | Método de UI Auxiliar / Función de Widget | `letrerprecio` | `listaSeleccionadas` (ValueEspaciosCasaGet) | `appTheme` | `letreroprecio` (Widget local) | `appTheme.onPrimaryContainer`, fuente e iconografía global |

---

## Análisis y Buenas Prácticas del Módulo

1. **Estandarización de Etiquetas:**
   * La función `letrerprecio` actúa como un formateador dinámico de precios que evalúa el campo `tipodetransaccion` (con valores como *"Venta"*, *"Renta"*, *"Venta/Renta"* o *"Traspaso"*) para construir de forma automática un letrero estilizado con la denominación monetaria (`moneda`).

2. **Acoplamiento Ligero:**
   * Este widget recibe los datos directamente como parámetro, lo que evita que deba escuchar listeners o providers globales de forma interna, haciéndolo sumamente portátil, eficiente y fácil de renderizar en cualquier parte del árbol de widgets (por ejemplo, dentro de listas de propiedades, tarjetas destacadas o detalles de ficha técnica).
