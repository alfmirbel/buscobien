# Inventario de Componentes - `lib/08_pantallas/widgets_comunes`

Este documento detalla el inventario de los archivos del subdirectorio **`D:\buscobien\lib\08_pantallas\widgets_comunes`**. Esta sección está diseñada para centralizar componentes gráficos reutilizables o helpers visuales pequeños que se comparten entre múltiples pantallas.

---

## Tabla de Inventario de Widgets Comunes

| Subdirectorio (si aplica) | Nombre del archivo | variables definidas en el archivo | clases | breve descripción de cada clase | variables de la clase | funciones o widgets definidos en la clase o archivo | breve descripción de cada función o widget | variables que utiliza | llamadas a otras clases o widgets |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | [widget_letrero_tipo_transaccion.dart](file:///D:/buscobien/lib/08_pantallas/widgets_comunes/widget_letrero_tipo_transaccion.dart) | *Ninguna* | *Ninguna* (Contiene una función utilitaria funcional de widget global) | N/A | N/A | - `letrerprecio()` | - `letrerprecio()`: Función global que toma una propiedad (`ValueEspaciosCasaGet`) y, mediante una estructura de conmutación `switch`, genera dinámicamente un widget `Text` de precio estilizado que se ajusta al tipo de transacción (Venta, Renta, Venta/Renta, Traspaso) con su denominación monetaria (`moneda`). | - `listaSeleccionadas` (`ValueEspaciosCasaGet`) <br>- `letreroprecio` (`Widget` local) | - `Text` <br>- `TextStyle` <br>- `ValueEspaciosCasaGet` <br>- `appTheme` |

---

## Observaciones sobre el Diseño de Widgets Reutilizables

1. **Bajo Acoplamiento (Stateless / Functional Helper):**
   * El componente `letrerprecio` no hereda de `StatefulWidget` ni `StatelessWidget`; en su lugar, se implementa como una función directa que retorna un `Widget`. Al recibir todos los datos requeridos por parámetro, no requiere dependencias de Riverpod o escuchas de red, lo que minimiza redibujados (re-renders) complejos en listas de alta densidad de elementos.

2. **Consistencia Visual centralizada en `appTheme`:**
   * La estilización tipográfica e iconográfica de precios y etiquetas utiliza de forma absoluta las propiedades de color de la paleta centralizada (`appTheme.onPrimaryContainer`), garantizando consistencia cromática completa en todo el ecosistema móvil de Buscobien.
