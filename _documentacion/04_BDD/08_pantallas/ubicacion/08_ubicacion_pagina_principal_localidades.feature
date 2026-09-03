# language: es
Característica: Pantalla Principal de Localidades (Mis Localidades)
  Como usuario de BuscoBien
  Quiero ver mis localidades guardadas y acceder a la búsqueda de nuevas zonas
  Para gestionar mis ubicaciones de interés y ver propiedades por zona

  Escenario: La pantalla muestra el título y dos botones de acción
    Dado que el usuario navega a la sección "Ubicación" (indiceInicial = 2)
    Cuando se renderiza "PaginaPrincipalListaLocalidades"
    Entonces el sistema debe mostrar el título "{iconoMiLocalidad.etiqueta} seleccionadas"
    Y debe mostrar el botón "Ingresa como usuario para guardar propiedades"
    Y debe mostrar el botón "Selecciona localidades para ver publicaciones de la zona"

  Escenario: El botón de login se muestra solo cuando no hay sesión iniciada
    Dado que el usuario no ha iniciado sesión (userId vacío)
    Cuando se renderiza "PaginaPrincipalListaLocalidades"
    Entonces el sistema debe mostrar el botón "Ingresa como usuario para guardar propiedades"
    Y el botón debe tener borde de 2px en color primario y fondo onPrimary
    Y al tocarlo debe abrir "dialogBoxFichaLogin"

  Escenario: El botón de login está oculto cuando hay sesión iniciada
    Dado que el usuario ha iniciado sesión
    Cuando se renderiza "PaginaPrincipalListaLocalidades"
    Entonces el sistema no debe mostrar el botón "Ingresa como usuario para guardar propiedades"
    Y debe mostrar un SizedBox de altura 0 en su lugar

  Escenario: El botón de buscar localidades navega a la búsqueda por CP
    Dado que el usuario está en "PaginaPrincipalListaLocalidades"
    Cuando el usuario presiona "Selecciona localidades para ver publicaciones de la zona"
    Entonces el sistema debe navegar a "AppRoutes.localidades" ("PaginaBuscaLocalidadGMaps")
    Y debe pasar arguments vacíos

  Escenario: La lista muestra localidades con CP distinto de 0
    Dado que el usuario tiene localidades guardadas en "userLocalidadesProvider"
    Cuando se renderiza la lista
    Entonces el sistema debe filtrar y mostrar solo localidades donde "cp != 0"
    Y cada localidad debe mostrar asentamiento, CP, estado, municipio, ciudad, zona y tipo

  Escenario: Cada localidad se muestra como una tarjeta con header y detalles
    Dado que el usuario tiene localidades guardadas
    Cuando se renderiza una tarjeta de localidad
    Entonces el sistema debe mostrar un header con fondo primario
    Y el header debe mostrar el asentamiento como título y el CP como subtítulo
    Y debe mostrar un botón de eliminar (icono Symbols.delete)
    Y debe mostrar una flecha de navegación (Symbols.arrow_forward_ios)

  Escenario: El usuario puede navegar a la pantalla principal desde una localidad
    Dado que el usuario está en "PaginaPrincipalListaLocalidades"
    Cuando el usuario presiona el ListTile de una localidad
    Entonces el sistema debe ejecutar "updateLocalidadEnSesion(localidadCp)"
    Y debe navegar a "AppRoutes.principal" con pushReplacementNamed
    Y los filtros de la pantalla principal deben actualizarse con la localidad seleccionada

  Escenario: El usuario puede eliminar una localidad guardada
    Dado que el usuario presiona el botón de eliminar en una localidad
    Cuando aparece el diálogo de confirmación "Eliminar Ubicación"
    Y el usuario presiona "Eliminar"
    Entonces el sistema debe llamar a "deleteUserLocalidadFromCouchDB(loc.id)"
    Y la localidad debe desaparecer de la lista

  Escenario: El usuario puede cancelar la eliminación de una localidad
    Dado que el usuario presiona el botón de eliminar en una localidad
    Cuando aparece el diálogo de confirmación
    Y el usuario presiona "Cancelar"
    Entonces el sistema debe cerrar el diálogo
    Y la localidad debe permanecer en la lista

  Escenario: La pantalla muestra estado vacío cuando no hay localidades guardadas
    Dado que el usuario no tiene localidades guardadas ("localidadesUsuario" vacío)
    Cuando se renderiza "PaginaPrincipalListaLocalidades"
    Entonces el sistema debe mostrar los dos botones de acción (login y buscar)
    Y no debe mostrar ninguna tarjeta de localidad
