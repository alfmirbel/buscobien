# language: es
Característica: Widget de Derechos Reservados
  Como usuario final
  Quiero ver el aviso de derechos reservados de la aplicación
  Para conocer la propiedad intelectual del producto

  Escenario: Visualización de derechos reservados en modo claro
    Dado que la aplicación está en modo claro
    Cuando el sistema renderiza `derechosReservadosClaro()`
    Entonces el sistema muestra una columna con separador superior de 60px
    Y muestra el texto "© 2026 Buscobien®. Todos los derechos reservados."
    Y el texto tiene color `appTheme.surface` y tamaño 10
    Y muestra un separador inferior de 20px

  Escenario: Visualización de derechos reservados en modo oscuro
    Dado que la aplicación está en modo oscuro
    Cuando el sistema renderiza `derechosReservadosObscuro()`
    Entonces el sistema muestra una columna con separador superior de 60px
    Y muestra el texto "© 2026 Buscobien®. Todos los derechos reservados."
    Y el texto tiene color `appTheme.onSurface` y tamaño 10
    Y muestra un separador inferior de 20px
