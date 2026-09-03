# language: es
Característica: Filtros de Búsqueda (Nivel de Gobierno, Tipo de Espacio y Transacción)
  Como usuario de BuscoBien
  Quiero filtrar las propiedades por nivel de gobierno, tipo de espacio y tipo de transacción
  Para encontrar exactamente el inmueble que necesito

  Escenario: El menú de nivel de gobierno muestra 5 opciones
    Dado que el usuario navegó a la sección "Propiedades"
    Cuando se renderiza el menú de nivel de gobierno
    Entonces el sistema debe mostrar 5 tabs: "Nacional", "Estado", "Municipio", "C.P." y "Localidad"
    Y la opción "Nacional" debe estar seleccionada por defecto

  Escenario: El usuario selecciona nivel de gobierno Estado
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Estado" en el menú de nivel de gobierno
    Entonces el sistema debe actualizar `menuNivelDeGobiernoProvider` con `seleccionMenuNivelDeGobierno = 1`
    Y debe actualizar `homeNavigationProvider` con `indiceNivelGobierno = 1`
    Y el tab debe mostrar la etiqueta del estado correspondiente

  Escenario: El usuario selecciona nivel de gobierno Municipio
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Municipio"
    Entonces el sistema debe actualizar `menuNivelDeGobiernoProvider` con `seleccionMenuNivelDeGobierno = 2`
    Y debe actualizar `homeNavigationProvider` con `indiceNivelGobierno = 2`
    Y el tab debe mostrar el municipio correspondiente

  Escenario: El usuario selecciona nivel de gobierno C.P.
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "C.P."
    Entonces el sistema debe actualizar `menuNivelDeGobiernoProvider` con `seleccionMenuNivelDeGobierno = 3`
    Y debe actualizar `homeNavigationProvider` con `indiceNivelGobierno = 3`
    Y el tab debe mostrar el código postal correspondiente

  Escenario: El usuario selecciona nivel de gobierno Localidad
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Localidad"
    Entonces el sistema debe actualizar `menuNivelDeGobiernoProvider` con `seleccionMenuNivelDeGobierno = 4`
    Y debe actualizar `homeNavigationProvider` con `indiceNivelGobierno = 4`
    Y el tab debe mostrar la localidad correspondiente

  Escenario: El menú de tipo de espacio muestra 5 opciones
    Dado que el usuario navegó a la sección "Propiedades"
    Cuando se renderiza el menú de tipo de espacio
    Entonces el sistema debe mostrar 5 tabs: "Normales", "Destacados", "Superdestacados", "Oportunidades" y "Remates"
    Y la opción "Normales" debe estar seleccionada por defecto

  Escenario: El usuario selecciona tipo de espacio Destacados
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Destacados"
    Entonces el sistema debe actualizar `menuTipoEspaciosProvider` con `seleccionMenuTipoEspacios = 1`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoEspacio = 1`

  Escenario: El usuario selecciona tipo de espacio Superdestacados
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Superdestacados"
    Entonces el sistema debe actualizar `menuTipoEspaciosProvider` con `seleccionMenuTipoEspacios = 0`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoEspacio = 0`

  Escenario: El usuario selecciona tipo de espacio Oportunidades
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Oportunidades"
    Entonces el sistema debe actualizar `menuTipoEspaciosProvider` con `seleccionMenuTipoEspacios = 3`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoEspacio = 3`

  Escenario: El usuario selecciona tipo de espacio Remates
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Remates"
    Entonces el sistema debe actualizar `menuTipoEspaciosProvider` con `seleccionMenuTipoEspacios = 4`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoEspacio = 4`

  Escenario: El menú de tipo de transacción muestra 5 opciones
    Dado que el usuario navegó a la sección "Propiedades"
    Cuando se renderiza el menú inferior de tipo de transacción
    Entonces el sistema debe mostrar 5 tabs: "Todas", "Venta", "Renta", "Venta/Renta" y "Traspaso"
    Y la opción "Todas" debe estar seleccionada por defecto

  Escenario: El usuario selecciona tipo de transacción Venta
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Venta" en el menú inferior
    Entonces el sistema debe actualizar `menuTipoDeTransaccionProvider` con `seleccionMenuTipoDePublicacion = 1`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoTransaccion = 1`

  Escenario: El usuario selecciona tipo de transacción Renta
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Renta"
    Entonces el sistema debe actualizar `menuTipoDeTransaccionProvider` con `seleccionMenuTipoDePublicacion = 2`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoTransaccion = 2`

  Escenario: El usuario selecciona tipo de transacción Venta/Renta
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Venta/Renta"
    Entonces el sistema debe actualizar `menuTipoDeTransaccionProvider` con `seleccionMenuTipoDePublicacion = 3`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoTransaccion = 3`

  Escenario: El usuario selecciona tipo de transacción Traspaso
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona el tab "Traspaso"
    Entonces el sistema debe actualizar `menuTipoDeTransaccionProvider` con `seleccionMenuTipoDePublicacion = 4`
    Y debe actualizar `homeNavigationProvider` con `indiceTipoTransaccion = 4`

  Escenario: El menú de nivel de gobierno flota al hacer scroll
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario hace scroll hacia abajo y luego hacia arriba
    Entonces el SliverAppBar del menú de nivel de gobierno debe reaparecer flotando
    Y debe tener `pinned: false` y `floating: true`

  Escenario: El menú de tipo de espacio flota al hacer scroll
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario hace scroll hacia abajo y luego hacia arriba
    Entonces el SliverAppBar del menú de tipo de espacio debe reaparecer flotando
    Y debe tener `pinned: false` y `floating: true`
