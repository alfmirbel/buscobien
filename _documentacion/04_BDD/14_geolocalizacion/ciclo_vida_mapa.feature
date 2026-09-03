# language: es
Característica: Ciclo de Vida del Controlador de Mapa
  Como usuario final
  Quiero que el mapa se inicialice y libere correctamente
  Para evitar fugas de memoria y errores al navegar

  Escenario: Inicialización del controlador de mapa al crear
    Dado que el usuario abre la pantalla de búsqueda de ubicación
    Cuando el widget del mapa se crea
    Entonces el sistema registra el controlador de Google Maps en el provider
    Y completa el Completer del controlador si no estaba completado

  Escenario: Liberación del controlador de mapa al cerrar pantalla
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y el controlador del mapa está activo
    Cuando el usuario navega fuera de la pantalla
    Entonces el sistema libera el controlador del mapa
    Y reinicia el Completer del controlador para futuras instancias

  Escenario: Manejo de marcadores en memoria
    Dado que el sistema almacena marcadores en el estado
    Cuando el usuario navega y regresa a la pantalla
    Entonces el sistema limpia el conjunto de marcadores antes de agregar nuevos
    Y agrega el nuevo marcador de ubicación actual al conjunto limpio
