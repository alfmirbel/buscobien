# language: es
Funcionalidad: Tus Espacios — Captura y Publicación de Propiedades

  Como promotor/propietario
  Quiero crear, editar y publicar mis propiedades en Buscobien (hasta 5 tipos de espacio)
  Para que aparezcan en el catálogo y pueda recibir leads de compradores

  Antecedentes:
    Dado que el usuario está autenticado con rol Promotor o Propietario
    Y accede a la sección "Tu Cuenta > Tus Espacios" de PrincipalSliversMenuInicial
    Y provider_espacios_casa_get.ClassCompraEspaciosNotifierProvider lista sus propiedades

  Escenario: Hub central de propiedades del usuario
    Dado que PaginaTusEspacios se inicializa
    Cuando provider_espacios_casa_get.future resuelve
    Entonces lista las propiedades del usuario (EspaciosCasa[])
    Y muestra CTAs: Crear nueva ficha, Editar (por cada una), Comprar
    Y el menuTipoEspaciosProvider permite filtrar por categoría

  Escenario: Crear ficha de captura (alta de propiedad)
    Dado que el usuario toca "Crear ficha de captura"
    Cuando CreaFichaCapturaPropiedad se abre
    Entonces muestra wizard/formulario con secciones: Tipo inmueble, Ubicación, Características, Precio, Fotos, Contacto
    Y los campos disponibles dependen del tipo de inmueble (tabla_tipopropiedad_vs_campos matriz)
    Y al Submit, validaciones locales disparan mensajes para campos requeridos

  Escenario: Submit exitoso de ficha nueva
    Dado que todos los campos requeridos están completos
    Cuando el usuario toca "Publicar"
    Entonces se invoca upsertEspacioPublicadoToCouchDB(tipoDeEspacio, datos)
    Y la API Node.js PUT/POST a CouchDB en la DB correspondiente (buscobien_casas_comprados_<tipo>)
    Y se crea el documento propiedad:<uuid> con timestamp
    Y la lista reactiva del provider actualiza y aparece la nueva propiedad
    Y SnackBar confirma y regresa a PaginaTusEspacios

  Escenario: Editar propiedad existente
    Dado que el usuario toca "Editar" en una de sus propiedades
    Cuando PaginaEditaEspacio se abre
    Entonces todos los campos del formulario vienen precargados con los datos del doc CouchDB
    Y el usuario puede modificar cualquier campo
    Y al submitir, PUT con el _rev correcto (409 si alguien más edita concurrentemente)

  Escenario: Conflicto de edición concurrente (409)
    Dado que dos usuarios/usuarios editaron el mismo idPropiedad
    Y el último PUT trae _rev = rev_viejo
    Cuando CouchDB responde 409 Conflict
    Entonces el sistema muestra SnackBar "Conflicto, recarga"
    Y reGET de la propiedad para obtener el _rev actualizado

  Escenario: Validación de fotoprincipal
    Dado que el usuario publicó sin haber marcado una foto principal
    Cuando upsertEspacioPublicadoToCouchDB evalúa datosPropiedadPublicar.espacioscasa.fotoprincipal
    Entonces faila con SnackBar "Debes marcar una foto principal antes de publicar"
    Y no hace el PUT

  Escenario: Filtrar propiedades por tipo de espacio
    Dado que el usuario en PaginaTusEspacios toca tab "Destacados"
    Cuando menuTipoEspaciosProvider cambia
    Entonces el provider refiltera su lista por tipoDeEspacio="Destacados"
    Y la UI muestra sólo las propiedades de ese tipo

  Escenario: Borrar una propiedad propia (no publicada o publicada)
    Dado que el usuario toca "Eliminar" en una de sus propiedades
    Cuando confirmación via Dialog aparece
    Entonces DELETE CouchDB con _rev
    Y quita de la lista reactiva

  Escenario: Sub-feature CompraEspacios (mercado secundario / transferencia)
    Dado que el usuario abre sub-feature "compra espacios" (compra_espacios/)
    Cuando PaginaCompraEspacios se inicializa
    Entonces muestra propiedades publicadas disponibles para compra/transfer antes
    Y al tap "Comprar", crea un doc CompraEspacio con idUsuario comprador + timestamp
    Y la propiedad queda transferida a "Tus Espacios" del comprador

  Escenario: Tabla matriz de campos por tipo inmueble
    Dado que el usuario selecciona "Departamento"
    Cuando tabla_tipopropiedad_vs_campos se consulta
    Entonces recamaras, banos, metroscuonstruidos aplican
    Y precioventa/preciorenta/moneda aplican
    Para "Terreno", el sistema ignora recamaras/banos (no aplica) y muestra metrosdeterreno como principal
