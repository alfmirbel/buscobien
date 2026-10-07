# language: es
Característica: Navegación del Módulo Grupos
  Como usuario autenticado
  Quiero navegar entre las secciones del módulo Grupos
  Para gestionar mis grupos, invitaciones y descubrir nuevos grupos

  Antecedentes:
    Dado que el usuario ha iniciado sesión en la aplicación
    Y se encuentra en el módulo "Grupos"

  @REQ-GPU-002 @REQ-GPU-007 @mapeo-auto
  Escenario: Visualización de pestañas de navegación
    Dado que el usuario se encuentra en el módulo Grupos
    Entonces el sistema deberá mostrar una barra de navegación inferior con tres destinos: "Mis Grupos", "Invitaciones" y "Descubrir"

  Escenario: Pestaña activa por defecto
    Dado que el usuario abre el módulo Grupos por primera vez
    Entonces el sistema deberá mostrar la pestaña "Mis Grupos" como activa por defecto

  @REQ-GPU-008 @mapeo-auto
  Escenario: Cambio de pestaña
    Dado que el usuario se encuentra en la pestaña "Mis Grupos"
    Cuando el usuario presiona la pestaña "Invitaciones"
    Entonces el sistema deberá mostrar la pantalla de Invitaciones
    Y el indicador de la pestaña "Invitaciones" deberá estar activo

  @REQ-GPU-008 @mapeo-auto
  Escenario: Badge de invitaciones pendientes
    Dado que el usuario tiene 2 invitaciones pendientes recibidas
    Cuando el usuario visualiza la barra de navegación
    Entonces el sistema deberá mostrar un badge numérico "2" en la pestaña "Invitaciones"

  @REQ-GPU-008 @mapeo-auto
  Escenario: Sin badge cuando no hay invitaciones pendientes
    Dado que el usuario no tiene invitaciones pendientes
    Cuando el usuario visualiza la barra de navegación
    Entonces el sistema deberá ocultar el badge en la pestaña "Invitaciones"

  @REQ-GPU-008 @mapeo-auto
  Escenario: Carga inicial de invitaciones
    Dado que el usuario abre el módulo Grupos
    Cuando la vista raíz se monta
    Entonces el sistema deberá cargar las invitaciones del usuario desde el servidor
    Y actualizar el contador de invitaciones pendientes
