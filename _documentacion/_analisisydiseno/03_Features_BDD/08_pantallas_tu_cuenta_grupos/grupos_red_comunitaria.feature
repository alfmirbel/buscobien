# language: es
Funcionalidad: Grupos — Red social comunitaria (grupos, membresías, avisos, chat grupal)

  Como promotor/agente
  Quiero crear/join grupos (asociación, inmobiliaria, temática) y colaborar via avisos, publicaciones y chat grupal
  Para coordinar la búsqueda de propiedades con compañeros y clientes

  Antecedentes:
    Dado que el usuario accede a "Tu Cuenta > Grupos" en PrincipalSliversMenuInicial
    Y GruposView muestra 3 tabs: Mis Grupos / Descubrir / Invitaciones
    Y los grupos tienen miembros con roles (admin, miembro)

  Escenario: Hub central GruposView 3 tabs
    Dado que el usuario abre GruposView
    Cuando los 3 tabs (Mis Grupos / Descubrir / Invitaciones) se renderizan
    Entonces el tab Invitaciones muestra badge con pendientes
    Y PageStorageKey preserva scroll al cambiar tab

  Escenario: Ver Mis Grupos
    Dado que el usuario en tab Mis Grupos
    Cuando GruposNotifier.listaMisGrupos.future resuelve
    Entonces muestra tarjetas de grupos donde currentUser ∈ miembros[]
    Y cada tarjeta muestra nombre + # miembros + rol del usuario
    Y tap → PageDetalleGrupo

  Escenario: Detalle del grupo (4 sub-tabs)
    Dado que el usuario tap en un grupo
    Cuando PageDetalleGrupo abre
    Entonces muestra 4 sub-tabs: Publicaciones / Miembros / Avisos / Chat
    Y infoRow con nombre del grupo y descripción
    Y tab Chat tiene CTA "Abrir chat completo"

  Escenario: Tab Publicaciones del grupo
    Dado que el usuario está en _TabPublicaciones
    Cuando PublicacionesGrupoNotifier.listaPublicaciones(grupoId).future resuelve
    Entonces muestra las propiedades/publicaciones compartidas en el grupo
    Y cada card es _TarjetaPublicacion con miniatura + precio + (quién compartió)

  Escenario: Tab Miembros
    Dado que el usuario está en _TabMiembros
    Cuando GruposNotifier.listaMiembros(grupoId) se consulta
    Entonces muestra lista con avatar, nombre y rol (admin/miembro)
    Y si currentUser es admin, puede eliminar miembros o cambiar roles

  Escenario: Admin crea aviso
    Dado que el usuario es admin del grupo y está en _TabAvisos
    Cuando toca "Crear aviso"
    Entonces abre formulario (título, contenido, fecha expiración opcional)
    Y al submitir, AvisosGrupoNotifier.creaAviso persiste en buscobien_avisos_grupo
    Y el aviso aparece en la lista _TarjetaAviso
    Y los miembros ven badge de nuevo aviso (doc mensaje_grupo tipo:'aviso')

  Escenario: Miembro solo ve avisos
    Dado que el usuario es miembro no-admin en _TabAvisos
    Cuando el tab renderiza
    Entonces puede ver avisos pero el CTA "Crear aviso" NO aparece
    Y puede marcar aviso como leído (opcional)

  Escenario: Chat grupal
    Dado que el usuario toca CTA "Abrir chat completo" en PageDetalleGrupo
    Cuando PageChatGrupo abre
    Entonces MensajesGrupoNotifier.listaMensajes(grupoId).future paginados
    Y barra input permite texto + "Compartir propiedad" + "Compartir lista"
    Y cada mensaje tiene etiqueta autor (avatar+nombre) y timestamp

  Escenario: Compartir propiedad/lista en chat grupal
    Dado que el usuario en PageChatGrupo toca "Compartir propiedad"
    Cuando selecciona una propiedad de "Tus Espacios"
    Entonces crea mensaje_grupo tipo:'propiedad' con payload {idPropiedad, idUsuarioCompartidor}
    Y renderiza _BurbujaPropiedad (igual que conocidos)
    Y todos los miembros pueden ver la tarjeta

  Escenario: Descubrir grupos nuevos
    Dado que el usuario en tab Descubrir abre PageDescubrirGrupos
    Cuando lista grupos públicos disponibles
    Entonces muestra tarjetas con nombre + tema + # miembros
    Y CTA "Unirse" disponible si currentUser no es miembro

  Escenario: Unirse a un grupo público
    Dado que el usuario tap "Unirse" en PageDescubrirGrupos
    Cuando GruposNotifier.unirseAGrupo(grupoId) ejecuta (para públicos)
    Entonces crea doc buscobien_grupos_miembros con rol="miembro"
    Y el grupo aparece inmediatamente en Mis Grupos
    Y sin aprobación de admin (grupo público)

  Escenario: Solicitar unirse a grupo privado
    Dado que el grupo es privado
    Cuando el usuario tap "Solicitar unirse"
    Entonces crea invitación de request en buscobien_invitaciones_grupos (estado='request')
    Y el admin del grupo ve la solicitud y puede aceptar/rechazar
    Y tras aprobación, agrega como miembro

  Escenario: Invitaciones a grupo (admin invita)
    Dado que el admin tap "Invitar" en PageDetalleGrupo
    Cuando GruposInvitacionesNotifier.enviarInvitacion(grupoId, usuariosIds[]) ejecuta
    Entonces crea invitaciones en buscobien_invitaciones_grupos con estado='pendiente'
    Y los destinatarios ven badge en tab Invitaciones

  Escenario: Aceptar invitación de grupo
    Dado que el destinatario abre PageInvitacionesGrupo
    Cuando tap "Aceptar"
    Entonces GruposInvitacionesNotifier.aceptarInvitacion crea doc miembro con rol
    Y marca invitación como 'aceptada'
    Y el grupo aparece en Mis Grupos reactivamente
    Y crea mensaje_grupo tipo:'sistema' "Nuevo miembro se unió"

  Escenario: ChatGrupoEmbebido en otras pantallas
    Dado que otra pantalla requiere chat embebido
    Cuando ChatGrupoEmbebido(grupoId) se renderiza
    Entonces muestra el chat funcional sin abrir pantalla completa
    Y reutiliza MensajesGrupoNotifier

  Escenario: Eliminar miembro (admin)
    Dado que el admin tap "Eliminar" en un miembro
    Cuando confirmación + GruposNotifier.eliminarMiembro
    Entonces DELETE de buscobien_grupos_miembros
    Y crea mensaje_grupo "XY fue eliminado del grupo"
