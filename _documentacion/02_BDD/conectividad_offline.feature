# language: es
Característica: Conectividad y modo offline
  Como usuario
  Quiero que la aplicación indique el estado de conexión
  Para saber si las operaciones online están disponibles

  Escenario: Pérdida de conexión durante uso normal
    Dado que el usuario tiene conexión y navega el catálogo
    Cuando pierde conexión a Internet
    Entonces el sistema muestra la pantalla sin conexión
