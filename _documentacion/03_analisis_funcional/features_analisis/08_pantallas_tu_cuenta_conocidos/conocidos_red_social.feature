# language: es
Funcionalidad: Conocidos — Red social privada (contactos, invitaciones, chat 1:1)

  Como usuario autenticado de Buscobien
  Quiero gestionar mis contactos (conocidos), invitar nuevos y chatear compartiendo propiedades/listas
  Para coordinar la búsqueda de propiedades con conocidos

  Antecedentes:
    Dado que el usuario está autenticado y accede a "Tu Cuenta > Conocidos"
    Y ConocidosView muestra 3 tabs: Mis Contactos | Descubrir | Invitaciones

  @REQ-CON-003 @mapeo-auto
  Escenario: Ver lista de Mis Contactos
    Dado que el usuario está en tab Mis Contactos
    Cuando conocidosNotifierProvider.listaConocidos.future resuelve
    Entonces muestra contactos filtrados por idUsuario==currentUser
    Y cada contacto tiene avatar, nombre y CTA tap → PagePerfilContacto

  @REQ-CON-011 @mapeo-auto
  Escenario: Ver perfil de un contacto
    Dado que el usuario tap un contacto
    Cuando PagePerfilContacto se renderiza
    Entonces muestra avatar, nombre, datos públicos
    Y CTAs: Chatear (si son conocidos) o Eliminar de contactos

  @REQ-CON-004 @mapeo-auto
  Escenario: Descubrir usuarios
    Dado que el usuario abre PageDescubrirUsuarios
    Cuando busca por nombre o email
    Entonces retorna lista de usuarios matcheantes
    Y cada tarjeta muestra CTA "Invitar" (si no son conocidos) / "Chatear" (si ya conocidos)

  @REQ-CON-005 @mapeo-auto
  Escenario: Enviar invitación a un usuario
    Dado que el usuario tap "Invitar" en PageDescubrirUsuarios
    Cuando InvitacionesNotifier.enviar(usuarioDestinoId) ejecuta
    Entonces crea doc en buscobien_invitaciones con estado="pendiente"
    Y el receptor ve badge en su tab Invitaciones
    Y SnackBar confirma envío

  @REQ-CON-005 @mapeo-auto
  Escenario: Recepción de invitación (tab Invitaciones)
    Dado que el receptor abre ConocidosView → tab Invitaciones
    Cuando PageInvitaciones renderiza
    Entonces lista invitaciones pendientes recibidas
    Y cada una con botones Aceptar / Rechazar

  @REQ-CON-006 @mapeo-auto
  Escenario: Aceptar invitación (crea relación bidireccional)
    Dado que el receptor tap "Aceptar"
    Cuando ConocidosNotifier.responderInvitacion(inv.id, aceptado) ejecuta
    Entonces actualiza el documento de la invitación en buscobien_invitaciones con status "accepted"
    Y el contacto aparece en Mis Contactos
    Y los dos usuarios aparecen en sus respectivos Mis Contactos reactivamente

  @REQ-CON-006 @mapeo-auto
  Escenario: Rechazar invitación
    Dado que el receptor tap "Rechazar"
    Cuando InvitacionesNotifier.rechazarInvitacion(inv) ejecuta
    Entonces marca doc busco_invitaciones estado="rechazada"
    Y NO crea relación en busco_conocidos
    Y el emisor verá estado rechazado si consulta

  @REQ-CON-007 @mapeo-auto
  Escenario: chat 1:1 con media diferenciada
    Dado que el usuario tap "Chatear" en PagePerfilContacto
    Cuando PageChatPrivado abre
    Entonces MensajesChatNotifier lista mensajes paginados por (origen, destino)
    Y muestra barras input para escribir mensaje de texto
    Y muestra CTAs "Compartir propiedad" y "Compartir lista" en barra input

  @REQ-CON-008 @mapeo-auto
  Escenario: Compartir propiedad en chat (burbuja especial)
    Dado que el usuario tap "Compartir propiedad" en PageChatPrivado
    Cuando selecciona una propiedad de su lista
    Entonces crea mensaje tipo:'propiedad' con payload {idPropiedad, ...}
    Y renderiza _BurbujaPropiedad (tarjeta foto + precio + ubicación)

  @REQ-CON-008 @mapeo-auto
  Escenario: Compartir lista en chat (burbuja especial)
    Dado que el usuario tap "Compartir lista"
    Cuando selecciona una de sus listas
    Entonces crea mensaje tipo:'lista' con payload {listaId, nombreLista, ...}
    Y renderiza _BurbujaLista (tarjeta nombre + # propiedades)

  @REQ-CON-009 @mapeo-auto
  Escenario: Tap en burbuja propiedad/lista del chat → navega
    Dado que el receptor tap en _BurbujaPropiedad del chat
    Cuando se dispara onTap
    Entonces navega a PaginaDetalleWidget (de 08_pantallas/propiedades)
    Y al regresar, sigue en el chat

  @REQ-CON-003 @mapeo-auto
  Escenario: Eliminar contacto
    Dado que el usuario tap "Eliminar" en PagePerfilContacto
    Cuando confirmación dialog aparece
    Entonces DELETE los 2 doc busco_conocidos_usuarios (bidireccional)
    Y el contacto desaparece de Mis Contactos reactivamente

  Escenario: Transaccionalidad aceptar (deuda)
    Dado queInterruptedExceptionInvitacion crea 2 conocidos + 1 mensaje
    Cuando falla la operación media (mensaje no crea)
    Entonces el sistema puede quedar inconsistente (deuda: usar _bulk_docs)
