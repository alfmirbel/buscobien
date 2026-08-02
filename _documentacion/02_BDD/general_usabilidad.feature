# language: es
Característica: Componentes globales y usabilidad
  Como usuario final
  Quiero contar con controles comunes y feedback visual
  Para comprender claramente el estado de cada acción

  Escenario: Diálogo de confirmación genérico
    Dado que el sistema requiere confirmar una acción
    Cuando presenta el componente de diálogo genérico
    Entonces el usuario comprende el mensaje y las opciones disponibles

  Escenario: Estados de carga y error
    Dado que una operación requiere espera
    Cuando ocurre un fallo
    Entonces el sistema muestra el estado de error con opción a reintentar
