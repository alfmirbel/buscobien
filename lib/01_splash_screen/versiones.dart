class AppVersion {
  final String version; // Formato x.y.z
  final String titulo; // Resumen corto (ej. "Actualización de Seguridad")
  final DateTime fecha; // Cuándo se lanzó
  final List<String> cambios; // Lista detallada de lo que se hizo
  final bool esCritica; // Opcional: para resaltar versiones importantes

  const AppVersion({
    required this.version,
    required this.titulo,
    required this.fecha,
    required this.cambios,
    this.esCritica = false,
  });
}

/*
Semántico (X.Y.Z): Usa un esquema como Mayor.Menor.Parche. 
Por ejemplo, 1.2.3 donde 1 es la versión mayor (cambios grandes), 
2 es la versión menor (nuevas funcionalidades) y 
3 es el parche (corrección de errores).
*/

final List<AppVersion> historialDeVersiones = [
  AppVersion(
    version: "Beta 0.07.053",
    titulo: "Listas compartidas: confirmación, detalle, chat integrado y botón guardar en ficha",
    fecha: DateTime(2026, 05, 24),
    esCritica: false,
    cambios: [
      "Nuevo: _dialogConfirmarCompartir() — diálogo M3 previo al compartido; muestra nombre de lista y destinatarios seleccionados con botones Cancelar/Compartir.",
      "Nuevo: pagina_detalle_lista_compartida.dart — PageDetalleListaCompartida: pantalla que carga y muestra las propiedades contenidas en una lista compartida usando WrapModernCardPropiedades con fallback multi-endpoint para tipodeespacio vacío.",
      "Nuevo: Botón Symbols.delete_outline en ListTile de tab Recibidas (ambos perfiles) → _dialogDejarDeCompartir() con confirmación M3 → dejarDeCompartir().",
      "Nuevo: onTap en ListTile de Recibidas y Enviadas navega a PageDetalleListaCompartida.",
      "Nuevo: _BurbujaLista en page_chat_privado.dart y page_chat_grupo.dart — burbuja tappable (GestureDetector) con Symbols.format_list_bulleted + nombre + 'Toca para ver las propiedades'; navega a PageDetalleListaCompartida construyendo ListaCompartidaModel mínimo desde listaCompartidaId.",
      "Nuevo: _BurbujaPropiedad rediseñado en ambos chats — GestureDetector de área completa, Symbols.home + nombre + 'Toca para ver la ficha' en itálica; navega a PaginaDetalleWidget con fromChatUserId: currentUserId.",
      "Nuevo: PaginaDetalleWidget.fromChatUserId (String?) — cuando no es null muestra Symbols.playlist_add en AppBar → _dialogGuardarEnLista() que carga listas del usuario, muestra diálogo de selección M3 y guarda con addPropiedadALista().",
      "Nuevo: compartirLista() envía mensaje de chat al destinatario con tipo: 'lista' y listaCompartidaId via enviarMensajeDirecto() al terminar el compartido exitosamente.",
      "Nuevo: listaCompartidaId añadido a MensajeModel y MensajeGrupoModel (campo JSON listaCompartidaId, valor por defecto '').",
      "Nuevo: enviarMensajeDirecto() acepta parámetro opcional listaCompartidaId para mensajes de tipo lista.",
      "Nuevo: _BurbujaMensaje en page_chat_grupo.dart recibe currentUserId como parámetro requerido; lo propaga a _BurbujaPropiedad y permite a _BurbujaLista acceder a él.",
      "Fix: Nombre de lista compartida adopta formato '\$listaNombreOrigen (de \$usuarioOrigenNombre)' en lugar del anterior prefijo 'Compartida por ...'.",
      "Fix M3: appbar_menu_tu_cuenta_usuario.dart — eliminado alias colorScheme, todos los colores a appTheme.xxx directo; unselectedBackgroundColor usa appTheme.surfaceContainerLow, SliverAppBar.backgroundColor usa appTheme.surface.",
      "CouchDB producción: creadas bases buscobien_listas_compartidas_usuarios y buscobien_listas_prop_compartidas con 4 índices Mango (idx-lista-compartida-dupla, idx-lista-compartida-origen, idx-lista-compartida-destino, idx-lista-prop-compartida).",
      "Archivos modificados: pagina_mis_listas.dart, pagina_detalle_lista_compartida.dart (nuevo), provider_listas_compartidas.dart, pagina_detalle_propiedad.dart, page_chat_privado.dart, page_chat_grupo.dart, mensaje_model.dart, mensaje_grupo_model.dart, provider_mensajes.dart, appbar_menu_tu_cuenta_usuario.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.052",
    titulo: "Tab Enviadas, overflow fix y compartirLista con retorno int",
    fecha: DateTime(2026, 05, 24),
    esCritica: false,
    cambios: [
      "Nuevo: Tab 'Enviadas' en Mis Listas muestra listas compartidas por el usuario (usuarioOrigenId == userId). Incluye botón 'Dejar de compartir' (Symbols.link_off) con diálogo de confirmación M3.",
      "Nuevo: Tab 'Compartidas' renombrado a 'Recibidas'; filtra solo listas donde usuarioDestinoId == userId. TabController pasó de length:2 a length:3.",
      "Nuevo: dejarDeCompartir() en provider_listas_compartidas.dart elimina el documento de lista compartida (PUT _deleted:true) y sus propiedades huérfanas en buscobien_listas_prop_compartidas.",
      "Bug fix: compartirLista() cambió retorno de bool a int (1=éxito, -1=duplicado, 0=error). _ejecutarCompartir() muestra SnackBar diferenciado: éxito, duplicado o error.",
      "Bug fix: _ejecutarCompartir() eliminó parámetro muerto listaPropiedadesNotifier que provocaba que la firma de compartirLista() fallara silenciosamente.",
      "Bug fix: overflow en _dialogCompartir corregido — SizedBox(height:270) reemplazado por ConstrainedBox(maxHeight: 40% pantalla) con ListView shrinkWrap:true.",
      "Archivos modificados: pagina_mis_listas.dart, provider_listas_compartidas.dart, inventario_03_listas.md, versiones.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.051",
    titulo: "Correcciones integrales al módulo Mis Listas",
    fecha: DateTime(2026, 05, 24),
    esCritica: false,
    cambios: [
      "Bug fix: Botón 'Borrar lista' ahora ejecuta el borrado real (antes onPressed era () {}). Implementado _dialogBorrarLista() con diálogo de confirmación M3.",
      "Bug fix: deleteLista() en provider_user_lists.dart obtiene el _rev del documento CouchDB internamente via GET, simplificando la firma a (docId, userId). Refresca la lista automáticamente tras borrado exitoso.",
      "Bug fix: _tabPropias() reemplaza FutureBuilder por ref.watch(userListsProvider) directamente, eliminando el problema de no-refresco al crear o borrar listas. El ListView es ahora reactivo al estado del provider.",
      "Bug fix: ref.listen(sessionProvider) en build() detecta cambio de sesión post-login desde _vistaInvitado y refresca listas automáticamente. Eliminado el setState incorrecto alrededor de dialogBoxFichaLogin.",
      "Bug fix: initState() pre-carga conocidosAceptadosProvider para que el botón Compartir esté habilitado desde el primer render si el usuario tiene conocidos.",
      "Bug fix: listapropiedadId en pagina_detalle_listas.dart onDismissed ahora usa listaProvider.rows[index].listapropiedad.listapropiedadId en lugar de la variable de clase incorrecta.",
      "Anti-duplicado: compartirLista() en provider_listas_compartidas.dart verifica mediante _existeCompartida() si la lista ya fue compartida con el destinatario antes de crear un nuevo registro.",
      "Anti-duplicado: _agregarPropiedadAFavoritas() en provider_me_gusta.dart verifica si la propiedad ya existe en la lista Favoritas antes de insertarla.",
      "Estilos M3: _mostrarDialogoCrearLista() corregido (fontSize 10→fontSizeDialogTitulo, eliminado backgroundColor en TextStyle). Diálogo confirmDismiss en pagina_detalle_listas.dart alineado a dialogBoxFichaLogin (appTheme.primary, Comfortaa, onError en lugar de Colors.white).",
      "Nuevo: _dialogBorrarLista() implementado con estilo M3 completo alineado a dialogBoxFichaLogin.",
      "Archivos modificados: pagina_mis_listas.dart, pagina_detalle_listas.dart, provider_user_lists.dart, provider_listas_compartidas.dart, provider_me_gusta.dart, inventario_03_listas.md, versiones.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.050",
    titulo: "Correcciones al flujo de selección y guardado de localidades",
    fecha: DateTime(2026, 05, 24),
    esCritica: false,
    cambios: [
      "Corregido: onTap de LocalidadesListScreen ya no sobrescribía la lista en memoria del usuario al seleccionar una localidad del catálogo SEPOMEX (se eliminó llamada incorrecta a setUserLocalSelectedFromLocalidades).",
      "Nuevo: verificación de duplicado (gdtLocalidadUsuario) en la UI antes de mostrar el diálogo de guardado; si la localidad ya existe, se muestra un SnackBar informativo y se navega a /principal sin duplicar.",
      "Nuevo: updateLocalidadEnSesion() se invoca al seleccionar cualquier localidad, con o sin sesión, para que los filtros de búsqueda reflejen la zona elegida de inmediato.",
      "Nuevo: al confirmar el guardado en el diálogo, se llama a fetchLocalidadesDeUsuario() post-escritura para refrescar la lista completa del usuario desde CouchDB.",
      "Rediseño de openDialogGuardaUserLocal() con estilos M3 alineados a dialogBoxFichaLogin: fondo appTheme.primary, textos appTheme.onPrimary, fuente Comfortaa, botón 'No' con appTheme.surface, barrierDismissible: false.",
      "Archivos modificados: screen_maestro_localidades.dart, inventario_08_pantallas_ubicacion.md, versiones.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.049",
    titulo: "Remediación y eliminación en Ubicaciones Guardadas",
    fecha: DateTime(2026, 05, 23),
    esCritica: false,
    cambios: [
      "Fijar de inmediato la localidad seleccionada en el catálogo SEPOMEX como activa en la sesión de búsqueda (updateLocalidadEnSesion).",
      "Mostrar localidades reales vinculadas al usuario desde CouchDB en lugar de la vista general temporal en pagina_principal_localidades.dart.",
      "Añadir botón 'Eliminar' para localidades con dialogBox interactivo y borrado directo a la BD (LocalidadesRepository.deleteUserLocalidad).",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.048",
    titulo: "Inmutabilidad completa del sistema de sesión — 5 fases.",
    fecha: DateTime(2026, 05, 18),
    esCritica: true,
    cambios: [
      "Fase 1 — SessionData inmutable: todos los campos de data_session.dart cambiados de 'var' a 'final'; constructor marcado 'const'; nuevo método copyWith() añadido para crear instancias modificadas sin mutar el objeto original.",
      "Fase 2 — Eliminación de mutaciones en provider_session.dart: setPerfilUsuarioByNombrePerfil() y setSessionVarValue() ahora crean nuevas instancias de SessionData vía copyWith() en lugar de mutar el objeto referenciado desde state. getUserIdNamePassByNameID() simplificado: las asignaciones redundantes post-resetInitialUserData() fueron eliminadas.",
      "Fase 3 — Precarga en segundo plano: principal_sliver_screen_menus_inicio.dart llama a getUserDataByNameInSessionData() de forma no bloqueante (sin await) tras restaurar la sesión, para que PaginaPerfilWidget encuentre los datos listos.",
      "Fase 4 — Dropdown optimizado: DropdownTipoUsuario.onChanged() en login_01_login_page.dart reducido de 9 llamadas setRoleFlag() a una sola llamada setNombrePerfil(), que ya ejecuta setPerfilUsuarioByNombrePerfil() internamente. Reduce 9 reconstrucciones a 1.",
      "Fase 5 — Caché de datos de usuario: nuevo campo isUserDataLoaded en AuthState; getUserDataByNameInSessionData() lo establece en true; resetInitialUserData() lo restablece en false. PaginaPerfilWidget verifica el flag en initState() y reutiliza el caché si los datos ya fueron cargados.",
      "Archivos modificados: data_session.dart, auth_state.dart, provider_session.dart, principal_sliver_screen_menus_inicio.dart, login_01_login_page.dart, pagina_perfil.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.047",
    titulo: "Corrección completa del sistema de sesión persistente.",
    fecha: DateTime(2026, 05, 18),
    esCritica: true,
    cambios: [
      "Bug crítico corregido: getSessionValuesFromLocalStorage() ahora se llama al iniciar la app (principal_sliver_screen_menus_inicio.dart), restaurando automáticamente la sesión del usuario sin necesidad de volver a iniciar sesión.",
      "Bug crítico corregido: deleteLocalSessionData() en pagina_perfil.dart se ejecuta correctamente al hacer logout (faltaban await y paréntesis de invocación).",
      "Corrección de inmutabilidad: getSessionValuesFromLocalStorage() y getUserIdNamePassByName() ahora crean nuevas instancias de SessionData en lugar de mutar el objeto existente, respetando la arquitectura inmutable de Riverpod.",
      "Nuevo: se guarda el hash SHA-256 de la contraseña (userPassHash) en FlutterSecureStorage para permitir reautenticación HTTP tras recuperar la sesión.",
      "Nuevo: isAuthenticated se establece correctamente en true al iniciar sesión y en false al cerrar sesión (logout y reset).",
      "Corrección de carrera: getUserDataByNameInSessionData() en login_01_login_page.dart ahora tiene await, garantizando que los datos completos del usuario estén disponibles antes de navegar al perfil.",
      "Archivos modificados: provider_session.dart, login_01_login_page.dart, pagina_perfil.dart, principal_sliver_screen_menus_inicio.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.046",
    titulo: "Cambio en la página de Busqueda de Espacios.",
    fecha: DateTime(2026, 05, 18),
    cambios: [
      "Se corrigió el comportamiento de la navegación del Login y Perfil.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.045",
    titulo: "Cambio de la navegación del Login y Perfil.",
    fecha: DateTime(2026, 05, 17),
    cambios: [
      "Se corrigió el comportamiento de la navegación del Login y Perfil.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.044",
    titulo: "Cambio de la fuente de Iconos.",
    fecha: DateTime(2026, 05, 16),
    cambios: ["Se agregó el paquete flutter pub add material_symbols_icons "],
  ),
  AppVersion(
    version: "Beta 0.07.043",
    titulo: "Cambio de la fuente de Iconos.",
    fecha: DateTime(2026, 05, 16),
    cambios: ["Se agregó el paquete flutter pub add material_symbols_icons "],
  ),
  AppVersion(
    version: "Beta 0.07.042",
    titulo: "Cambio de la fuente de Iconos.",
    fecha: DateTime(2026, 05, 16),
    cambios: [
      "Se modifica el archivo pubspec.yaml para agregar la siguiente referencia: ",
      "fonts - family: MaterialIcons - fonts - asset: assets/fonts/MaterialIcons-Regular.ttf.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.041",
    titulo: "Botón de favoritos en tarjeta de propiedad",
    fecha: DateTime(2026, 05, 15),
    cambios: [
      "Se reemplaza ❤️ por ❤️ en el botón de favoritos.",
      "Se reemplaza el color rojo por el color de la marca.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.040",
    titulo: "Motor social — Compartir propiedades, Me gusta y Avisos",
    fecha: DateTime(2026, 05, 15),
    cambios: [
      "Me gusta en tarjeta de propiedad: botón ❤️ en sección LETRERO PROMOCIONAL; guarda en buscobien_megusta_propiedades; crea lista 'Favoritas' automáticamente en el primer me gusta.",
      "Mis Listas: TabBar Propias/Compartidas; botón Compartir por lista (máx 5 conocidos); nueva DB buscobien_listas_compartidas_usuarios.",
      "Compartir con Grupo y Con Conocido desde el menú del carrusel de fotos (PopupMenuItems nuevos).",
      "Pantallas secundarias PageCompartirConGrupo y PageCompartirConConocido.",
      "Tab Publicaciones en Detalle Grupo: datos reales desde buscobien_grupos_publicaciones, paginación, 'Dejar de compartir'.",
      "Tab Avisos en Detalle Grupo: FAB 'Publicar aviso', tarjetas estilizadas, eliminar solo para el autor.",
      "Dialog Invitar en Detalle Grupo: CheckboxList + botón Enviar; filtra usuario actual y miembros existentes.",
      "Burbujas de tipo 'propiedad' en chat privado y chat grupal con botón 'Ver propiedad'.",
      "Corrección filtro id_usuario (snake_case) en page_descubrir_usuarios.dart.",
      "Lista 'Favoritas' siempre primera en Mis Listas.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.039",
    titulo: "Ajustes a Iconos y FAB",
    fecha: DateTime(2026, 05, 13),
    cambios: ["Se ajustaron los FAB de Mi Cuenta"],
  ),
  AppVersion(
    version: "Beta 0.07.038",
    titulo: "Solución definitiva a renderizado de iconos en Web",
    fecha: DateTime(2026, 05, 13),
    cambios: [
      "Se analizaron los motivos del fallo de renderizado de Icons.mail y otros iconos en Flutter Web (WASM/CanvasKit).",
      "El problema se debe al mecanismo de tree-shaking de fuentes de Flutter y a la falta de mapeo de ciertos codepoints (como 0xe158) en navegadores específicos.",
      "Se incrustaron las hojas de estilo de Google Fonts (Material Icons y Material Icons Outlined) nativamente en web/index.html para evitar depender exclusivamente del motor de renderizado de Flutter Web.",
      "Se validó el uso de iconos clásicos como Icons.email (codepoint 0xe22a) en lugar de Icons.mail en widget_wrap_modern_card.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.037",
    titulo: "Corrección de iconos en interfaces de web/WASM",
    fecha: DateTime(2026, 05, 13),
    cambios: [
      "Se reemplaza 'Contactos pendientes' por 'Conocidos pendientes' en la pantalla de Mis Contactos.",
      "Se reemplaza 'Lista de contactos' por 'Mis Conocidos' en la pantalla de Mis Contactos.",
      "Se reemplaza 'Nueva lista' por 'Nuevo grupo' en la pantalla de Mis Grupos.",
      "Se reemplaza 'Listas' por 'Grupos' en la pantalla de Mis Grupos.",
      "Se reemplaza 'Nueva lista' por 'Nuevo grupo' en la pantalla de Mis Listas.",
      "Se reemplaza 'Listas' por 'Grupos' en la pantalla de Mis Listas.",
      "Archivos modificados: widget_mis_contactos.dart, widget_mis_grupos.dart, widget_mis_listas.dart, widget_pantalla_crea_grupo.dart, widget_pantalla_lista_grupos.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.036",
    titulo:
        "Corrección de iconos de Mis Contactos, Mis Grupos y Mis Listas para web/WASM",
    fecha: DateTime(2026, 05, 12),
    cambios: [
      "Se eliminan encabezados de las secciones de Mis Contactos, Mis Grupos y Mis Listas.",
      "Ajustes varios a las páginas.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.035",
    titulo: "Corrección de iconos Correo y Mensaje para web/WASM",
    fecha: DateTime(2026, 05, 12),
    cambios: [
      "Se reemplaza Icons.mail (codepoint 0xe3c3) por Icons.email (codepoint 0xe22a) en el botón 'Correo' de la tarjeta de propiedades.",
      "Se reemplaza Icons.chat (codepoint 0xe153) por Icons.forum (codepoint 0xe2c3) en el botón 'Mensaje' de la tarjeta de propiedades.",
      "Ambos sustitutos son iconos del rango clásico MaterialIcons ampliamente soportados en navegadores web y compilación WASM.",
      "Se mantiene la semántica visual: sobre de correo electrónico para 'Correo' y bocadillos de diálogo para 'Mensaje'.",
      "Archivo modificado: widget_wrap_modern_card.dart.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.033",
    titulo: "Botón Mensaje en tarjeta de propiedad",
    fecha: DateTime(2026, 05, 11),
    cambios: [
      "Se sustituye el botón 'Invitar' por 'Mensaje' en la tarjeta de propiedades (WrapModernCardPropiedades).",
      "Al pulsar 'Mensaje', si el usuario no ha iniciado sesión se muestra el diálogo de login.",
      "Si el usuario está autenticado, se agrega al promotor como contacto aceptado en Mis Conocidos (status: 'accepted') sin pasar por pendiente.",
      "Se verifica si ya existe la relación de contacto para evitar duplicados en CouchDB.",
      "Se envía un mensaje automático al promotor con nombre del usuario y datos de la propiedad de interés.",
      "Se agrega método agregarContactoAceptado() en ConocidosNotifier.",
      "Se agrega función top-level enviarMensajeDirecto() en provider_mensajes.dart para envíos sin overhead del stream.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.032",
    titulo: "Recuperación de contraseña por enlace seguro",
    fecha: DateTime(2026, 05, 09),
    esCritica: true,
    cambios: [
      "Flujo completo de recuperación de contraseña mediante deep link seguro.",
      "Nueva pantalla: Solicitar recuperación (correo electrónico + perfil de usuario).",
      "Nueva pantalla: Cambio de contraseña (destino del enlace enviado por correo).",
      "Token de recuperación SHA-256 con expiración de 1 hora almacenado en CouchDB.",
      "Soporte para las tres bases de datos de usuarios: Usuario, Promotor y Propietario.",
      "Indicador visual de fortaleza de contraseña (débil / media / fuerte).",
      "Deep links configurados: Android App Links (autoVerify) e iOS URL Scheme.",
      "Archivos de verificación de dominio en web/.well-known/ (assetlinks.json y apple-app-site-association).",
      "Microservicio Node.js buscobien-mailer desplegado en citigov.cloud (pm2 + Apache proxy).",
      "Se agrega dependencia app_links ^6.4.0 para manejo de deep links en Android, iOS y Web.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.031",
    titulo: "Corrección de iconos para compatibilidad web",
    fecha: DateTime(2026, 05, 08),
    cambios: [
      "Se reemplaza icono Icons.account_box (codepoint 0xee34, rango extendido) por Icons.contact_mail (codepoint 0xe18a, rango clásico) en el botón Contacto de la tarjeta de propiedades.",
      "Se corrige la no visualización del icono en navegadores web debido a tree-shaking y caché de fuentes.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.030",
    titulo: "Revisión de los iconos de las propiedades y del loguin",
    fecha: DateTime(2026, 05, 08),
    cambios: [
      "Se cambia el icono de contacto por el icono de la cuenta del usuario.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.029",
    titulo: "Cambios a la ficha de la propiedad",
    fecha: DateTime(2026, 05, 07),
    cambios: [
      "Se agrega barra de acciones a la tarjeta de la propiedad.",
      "Botón Contacto: muestra datos del promotor en un diálogo.",
      "Botón Teléfono: realiza llamada directa (solo Android e iOS).",
      "Botón Correo: abre cliente de correo con el destinatario precargado.",
      "Botón Invitar: envía invitación a Mis Conocidos; si no hay sesión, abre el Login.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.028",
    titulo: "Chat en tiempo real",
    fecha: DateTime(2026, 05, 05),
    cambios: [
      "Implementación del chat en timepo real con CouchDB Change Feed.",
    ],
  ),
  AppVersion(
    version: "Beta 0.07.027",
    titulo: "Seguridad de claves de la aplicación",
    fecha: DateTime(2026, 05, 04),
    cambios: ["Implementación de seguridad de claves de la aplicación."],
  ),
  AppVersion(
    version: "Beta 0.06.026",
    titulo: "Desarrollo de la funcionalidad de Social Media",
    fecha: DateTime(2026, 04, 30),
    cambios: ["Migraciópn del desarrollo a Antogravity."],
  ),
  AppVersion(
    version: "Beta 0.06.025",
    titulo: "Revisión con Antigravity",
    fecha: DateTime(2026, 04, 15),
    cambios: ["Migraciópn del desarrollo a Antogravity."],
  ),

  AppVersion(
    version: "Beta 0.05.024",
    titulo: "Ajustes de formato",
    fecha: DateTime(2026, 03, 13),
    cambios: ["Ajustes de formato de los elementos de las landing pages."],
  ),
  AppVersion(
    version: "Beta 0.05.023",
    titulo: "Corrección de error",
    fecha: DateTime(2026, 02, 24),
    cambios: [
      "Ajustes de formato de los elementos de las listas.",
      "Revisión general del proyectos.",
      "Ajustes al login y logout.",
    ],
  ),
  AppVersion(
    version: "Beta 0.05.022",
    titulo: "Corrección de error",
    fecha: DateTime(2026, 02, 17),
    cambios: ["Correción al mostrar las propiedades de las listas"],
  ),
  AppVersion(
    version: "Beta 0.05.021",
    titulo: "Corrección de error",
    fecha: DateTime(2026, 02, 13),
    cambios: [
      "Se cambio 'Tus' por 'Mis'.",
      "Correción en agregar a una lista ",
    ],
  ),
  AppVersion(
    version: "Beta 0.06.021",
    titulo: "Nuevas funcionalidades",
    fecha: DateTime(2026, 02, 12),
    cambios: [
      "Se agrego la funcionalidad del manejo de listas de propiedades.",
    ],
  ),
  AppVersion(
    version: "Beta 0.05.021",
    titulo: "Revisión",
    fecha: DateTime(2026, 01, 29),
    cambios: ["Corrección navegación de las landing pages."],
  ),
  AppVersion(
    version: "Beta 0.05.020",
    titulo: "Revisión",
    fecha: DateTime(2026, 01, 29),
    cambios: ["Corrección la vista de fotos para usuarios."],
  ),
  AppVersion(
    version: "Beta 0.05.019",
    titulo: "Revisión",
    fecha: DateTime(2026, 01, 29),
    cambios: ["Corrección del paginador."],
  ),
  AppVersion(
    version: "Beta 0.05.018",
    titulo: "Revisión",
    fecha: DateTime(2026, 01, 27),
    cambios: [
      "Revisión del procedimiento de login y registro.",
      "Se gregan los diferentes perfiles al login.",
    ],
  ),
  AppVersion(
    version: "Beta 0.05.017",
    titulo: "Contenido",
    fecha: DateTime(2026, 01, 26),
    cambios: ["Condiciones de usp del sitio de pruebas y demostración..."],
  ),
  AppVersion(
    version: "Beta 0.05.016",
    titulo: "Contenido",
    fecha: DateTime(2026, 01, 26),
    cambios: ["Ajuste de textos de las landing pages.."],
  ),

  AppVersion(
    version: "Beta 0.05.015",
    titulo: "Diseño UI",
    fecha: DateTime(2026, 01, 25),
    cambios: ["Cambio de la landing page general.."],
  ),
  AppVersion(
    version: "Beta 0.05.014",
    titulo: "Fork",
    fecha: DateTime(2026, 01, 24),
    cambios: [
      "Correcciones de Imágenes.",
      "Cambio del menu principal de propiedades.",
    ],
  ),
  AppVersion(
    version: "Beta 0.05.013",
    titulo: "Fork",
    fecha: DateTime(2026, 01, 24),
    cambios: ["Ajustes colores de Imágenes."],
  ),
  AppVersion(
    version: "Beta 0.05.012",
    titulo: "Fork",
    fecha: DateTime(2026, 01, 23),
    cambios: ["Se agrega el menu de las landing pages."],
  ),
  AppVersion(
    version: "Beta 0.04.012",
    titulo: "Legal",
    fecha: DateTime(2026, 01, 22),
    cambios: [
      "Se agrega los Términos y Condiciones y Aviso de Privacidad al registro.",
    ],
  ),
  AppVersion(
    version: "Beta 0.04.011",
    titulo: "Correcciones",
    fecha: DateTime(2026, 01, 21),
    cambios: ["Ajustes a la pagina de registro."],
  ),
  //-------------------------
  AppVersion(
    version: "Beta 0.03.011",
    titulo: "Optimización de UI",
    fecha: DateTime(2026, 01, 19),
    cambios: [
      "Cambio tamaño del icono de mapa.",
      "Reevisión de la compresión de fotos.",
      "Optimización de la pantalla de captura de propiedades.",
    ],
  ),
  AppVersion(
    version: "Beta 0.03.010",
    titulo: "Corrección de UI",
    fecha: DateTime(2026, 01, 18),
    cambios: [
      "Se ajusto el enfoque del mapa principal.",
      "Correcicón de los colores de los FABs de mapas.",
      "Correcicón del Fabicon.ico.",
      "Correcicón de iconos AppBar.",
    ],
  ),
  AppVersion(
    version: "Beta 0.03.009",
    titulo: "Corrección de UI",
    fecha: DateTime(2026, 01, 17),
    cambios: [
      "Se ajusto la rutina de mapas.",
      "Correcicón de los colores de los FABs de mapas.",
    ],
  ),
  AppVersion(
    version: "Beta 0.03.008",
    titulo: "Corrección de UI",
    fecha: DateTime(2026, 01, 17),
    cambios: [
      "Cambio del Favicon.",
      "Reverse a true en la pantalla de Login.",
      "Se enmarco el mapa de propiedades.",
    ],
  ),
  AppVersion(
    version: "Beta 0.03.007",
    titulo: "Agrega funcionalidad y ajustes de colores",
    fecha: DateTime(2026, 1, 16),
    cambios: [
      "Se agrega Mapa de propiedades y el FAB",
      "Se ajusta color del CirculasProcessIndicator.",
    ],
  ),
  AppVersion(
    version: "Beta 0.02.006",
    titulo: "Optimización de la funcionalidad",
    fecha: DateTime(2026, 1, 16),
    cambios: ["Optimización de la tarjeta principal."],
  ),
  AppVersion(
    version: "Beta 0.02.006",
    titulo: "Optimización de la funcionalidad",
    fecha: DateTime(2026, 1, 15),
    cambios: ["Optimización del carousel de fotos."],
  ),
  AppVersion(
    version: "Beta 0.02.005",
    titulo: "Optimización de la funcionalidad",
    fecha: DateTime(2026, 1, 07),
    cambios: ["Optimización de la carga de multiples fotos."],
  ),
  AppVersion(
    version: "Beta 0.02.004",
    titulo: "Optimización de la funcionalidad",
    fecha: DateTime(2026, 1, 07),
    cambios: ["Optimización de la lista de fotos."],
  ),
  AppVersion(
    version: "Beta 0.02.003",
    titulo: "Optimización de la funcionalidad",
    fecha: DateTime(2026, 1, 07),
    cambios: ["Optimización de las mini fotos."],
  ),
  AppVersion(
    version: "Beta 0.02.002",
    titulo: "Mejoras de UI",
    fecha: DateTime(2026, 1, 07),
    cambios: ["Optimización de las mini fotos."],
  ),
  AppVersion(
    version: "Beta 0.02.001",
    titulo: "Optimización de la funcionalidad",
    fecha: DateTime(2026, 1, 05),
    cambios: ["Generación del PDF de la ficha de la propiedad."],
  ),
  AppVersion(
    version: "Beta 0.01.001",
    titulo: "Mejoras de UI",
    fecha: DateTime(2026, 1, 05),
    cambios: ["Generación de la ficha de la propiedad."],
  ),
  AppVersion(
    version: "Beta 0.00.001",
    titulo: "Mejoras de UI",
    fecha: DateTime(2025, 1, 05),
    cambios: ["Funcionalidad de la tarjeta de las propiedades."],
  ),
  AppVersion(
    version: "Beta 0.00.000",
    titulo: "Versión inicial para revisión de funcionalidad.",
    fecha: DateTime(2026, 12, 18),
    esCritica: true,
    cambios: ["Versión inicial para revisión de funcionalidad."],
  ),

  /*
  AppVersion(
    version: "1.0.0",
    titulo: "Lanzamiento Inicial",
    fecha: DateTime(2023, 12, 20),
    cambios: [
      "Lanzamiento oficial de la aplicación buscobien.",
      "Integración con base de datos CouchDB.",
      "Autenticación de usuarios.",
    ],
  ),
  */
];

String versionActual = historialDeVersiones[0].version;
