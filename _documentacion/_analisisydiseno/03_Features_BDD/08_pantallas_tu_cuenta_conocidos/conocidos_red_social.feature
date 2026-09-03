# language: es
Funcionalidad: Conocidos — Red social privada (contactos, invitaciones, chat 1:1)

  Como usuario autenticado de Buscobien
  Quiero gestionar mis contactos (conocidos), invitar nuevos y chatear compartiendo propiedades/listas
  Para coordinar la búsqueda de propiedades con conocidos

  Antecedentes:
    Dado que el usuario está autenticado y accede a "Tu Cuenta > Conocidos"
    Y ConocidosView muestra 3 tabs: Mis Contactos | Descubrir | Invitaciones

  Escenario: Ver lista de Mis Contactos
    Dado que el usuario está en tab Mis Contactos
    Cuando conocidosNotifierProvider.listaConocidos.future resuelve
    Entonces muestra contactos filtrados por idUsuario==currentUser
    Y cada contacto tiene avatar, nombre y CTA tap → PagePerfilContacto

  Escenario: Ver perfil de un contacto
    Dado que el usuario tap un contacto
    Cuando PagePerfilContacto se renderiza
    Entonces muestra avatar, nombre, datos públicos
    Y CTAs: Chatear (si son conocidos) o Eliminar de contactos

  Escenario: Descubrir usuarios
    Dado que el usuario abre PageDescubrirUsuarios
    Cuando busca por nombre o email
    Entonces retorna lista de usuarios matcheantes
    Y cada tarjeta muestra CTA "Invitar" (si no son conocidos) / "Chatear" (si ya conocidos)

  Escenario: Enviar invitación a un usuario
    Dado que el usuario tap "Invitar" en PageDescubrirUsuarios
    Cuando InvitacionesNotifier.enviar(usuarioDestinoId) ejecuta
    Entonces crea doc en buscobien_invitaciones con estado="pendiente"
    Y el receptor ve badge en su tab Invitaciones
    Y SnackBar confirma envío

  Escenario: Recepción de invitación (tab Invitaciones)
    Dado que el receptor abre ConocidosView → tab Invitaciones
    Cuando PageInvitaciones renderiza
    Entonces lista invitaciones pendientes recibidas
    Y cada una con botones Aceptar / Rechazar

  Escenario: Aceptar invitación (crea relación bidireccional)
    Dado que el receptor tap "Aceptar"
    Cuando InvitacionesNotifier.aceptarInvitacion(inv) ejecuta
    Entonces crea 2 doc en buscobien_conocidos_usuarios (origen+destino bidireccional)
    Y crea mensaje de bienvenida en buscobien_mensajes tipo:'sistema'
    Y marca la invitación como "aceptada"
    Y los dos usuarios aparecen en sus respectivos Mis Contactos reactivamente

  Escenario: Rechazar invitación
    Dado que el receptor tap "Rechazar"
    Cuando InvitacionesNotifier.rechazarInvitacion(inv) ejecuta
    Entonces marca doc busco_invitaciones estado="rechazada"
    Y NO crea relación en busco_conocidos
    Y el emisor verá estado rechazado si consulta

  Escenario: chat 1:1 con media diferenciada
    Dado que el usuario tap "Chatear" en PagePerfilContacto
    Cuando PageChatPrivado abre
    Entonces MensajesChatNotifier lista mensajes paginados por (origen, destino)
    Y muestra barras input para escribir mensaje de texto
    Y muestra CTAs "Compartir propiedad" y "Compartir lista" en barra input

  Escenario: Compartir propiedad en chat (burbuja especial)
    Dado que el usuario tap "Compartir propiedad" en PageChatPrivado
    Cuando selecciona una propiedad de su lista
    Entonces crea mensaje tipo:'propiedad' con payload {idPropiedad, ...}
    Y renderiza _BurbujaPropiedad (tarjeta foto + precio + ubicación)

  Escenario: Compartir lista en chat (burbuja especial)
    Dado que el usuario tap "Compartir lista"
    Cuando selecciona una de sus listas
    Entonces crea mensaje tipo:'lista' con payload {listaId, nombreLista, ...}
    Y renderiza _BurbujaLista (tarjeta nombre + # propiedades)

  Escenario: Tap en burbuja propiedad/lista del chat → navega
    Dado que el receptor tap en _BurbujaPropiedad del chat
    Cuando se dispara onTap
    Entonces navega a PaginaDetalleWidget (de 08_pantallas/propiedades)
    Y al regresar, sigue en el chat

  Escenario: Eliminar contacto
    Dado que el usuario tap "Eliminar" en PagePerfilContacto
    Cuando confirmación dialog aparece
    Entonces DELETE los 2 doc busco_conocidos_usuarios (bidireccional)
    Y el contacto desaparece de Mis Contactos reactivamente

  Escenario: Transaccionalidad aceptar (deuda)
    Dado queInterruptedExceptionInvitacion crea 2 conocidos + 1 mensaje
    Cuando falla la operación media (mensaje no crea)
    Entonces el sistema puede quedar inconsistente (deuda: usar _bulk_docs)
