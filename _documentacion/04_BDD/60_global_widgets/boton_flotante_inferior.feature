# language: es
Característica: Botón Flotante Inferior Fijo
  Como usuario final
  Quiero tener acceso rápido a acciones comunes desde la parte inferior
  Para navegar o ejecutar acciones sin desplazarme

  Escenario: Botón flotante inferior fijo con texto
    Dado que el sistema necesita mostrar un botón de acción flotante
    Y la etiqueta es "Guardar"
    Y el callback `onTap` está definido
    Cuando el sistema renderiza el botón flotante inferior
    Entonces el sistema muestra un botón elevado 6.0
    Y el botón tiene ancho 200 y altura 40
    Y el botón tiene radio de borde 8
    Y el fondo del botón es `appTheme.primary`
    Y el texto tiene color `appTheme.onSecondary`, tamaño 14 y negrita
    Y al presionar, ejecuta el callback `onTap`
