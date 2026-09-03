# language: es
Característica: Gestión de Localidades del Usuario

  Como usuario de Buscobien
  Quiero guardar mis localidades favoritas (CP, calle, sección INE, coordenadas)
  Para filtrar propiedades y poblar menú nivel gobierno

  Antecedentes:
    Dado que UsuarioLocalidades (@freezed) modela: idCp, idUsuario, pais, localidadCp, calle, seccionine, lat, lon, timestamp
    Y ClassUserLocalNotifierProvider expone CRUD reactivo
    Y LocalidadesRepository accede a buscobien_localidades_usuario + vista SEPOMEX

  Escenario: Crear localidad usuario con anti-duplicado
    Dado que usuario agrega localidad (CP + calle + sección INE)
    Cuando writeUserLocalidadToCouchDB() ejecuta
    Entonces verifica NO existe mismo idUsuario + localidadCp + calle
    Y guarda en buscobien_localidades_usuario con timestamp

  Escenario: Listar localidades del usuario reactivamente
    Dado que usuario abre Mi Cuenta → Localidades
    Cuando fetchLocalidadesDeUsuario(userId) ejecuta
    Entonces consulta vista CouchDB y actualiza estado Notifier
    Y getUserLocalidadesFutureProvider provee Future<List> para UI

  Escenario: Eliminar localidad con _rev
    Dado que usuario borra localidad de su lista
    Cuando deleteUserLocalidadFromCouchDB(docId, rev) ejecuta
    Entonces PUT _deleted=true en CouchDB
    Y resetea estado local (resetlistaLocalidadesUsuario)

  Escenario: Búsqueda SEPOMEX por CP para menú gobierno
    Dado que menú Nivel Gobierno necesita tabs dinámicas
    Cuando fetchByCodigoPostal(cp) ejecuta
    Entonces consulta buscobien_sepomex_localidades (vista SEPOMEX)
    Y retorna localidades para poblar tabs (asentamiento, municipio, estado)

  Escenario: Sincronización selección local ↔ modelo GET
    Dado que usuario selecciona localidad en UI
    Cuando setLocalidadSeleccionada() actualiza estado
    Entonces setUserLocalFromUserLocalGet() mantiene consistencia
    Y addLocalidad2UserLocalidad() agrega a lista temporal