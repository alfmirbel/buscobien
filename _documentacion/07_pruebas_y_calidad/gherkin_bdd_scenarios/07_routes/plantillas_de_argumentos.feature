# language: es
Característica: Plantillas y clases de argumentos de navegación
  Como desarrollador
  Quiero conocer las plantillas globales de argumentos
  Para entender el estado compartido entre pantallas

  @REQ-ROUT-009
  Escenario: routes_parameters define clases de resultado y de argumentos
    Cuando se revisa `routes_parameters.dart`
    Entonces existen `ResultadoGuardaFoto`, `ResultSaveFoto`, `ArgumentsLocalidad` y `ArgumentsListaLocalidad`

  @REQ-ROUT-009
  Escenario: routes_parameters define 11 variables globales de plantilla
    Cuando se revisa `routes_parameters.dart`
    Entonces existen `parameterLocalidad`, `parametrosListaFotos`, `parameterEditaEspacio`, `parameterEditaFotos`, `inicializaValueGetCasa`, `parameterFotoPrincipal`, `parameterActualizaEspacio`, `parameterPaginaChecaConeccion`, `parameterCapturaFotosCasa`, `parameterPaginaMenuTipoTransaccion` y `parameterGestionFoto`

  @REQ-ROUT-009
  Escenario: Los valores iniciales de las plantillas son predecibles
    Cuando se lee `parameterLocalidad`
    Entonces contiene {"cp": 3100}
    Y `parametrosListaFotos` inicia con "skip" 0, "limit" 0 e "indiceListaPropiedad" 0

  @REQ-ROUT-011
  Escenario: Las plantillas son mutables y compartidas entre pantallas
    Dado que una pantalla de fotos modifica `parameterEditaFotos`
    Cuando otra pantalla lee `parameterEditaFotos`
    Entonces observa el valor modificado porque la variable es global y mutable

  @REQ-ROUT-011
  Escenario: Las plantillas duplicadas no se sincronizan entre sí
    Cuando se modifica `parameterEditaEspacio`
    Entonces `parameterEditaFotos` e `inicializaValueGetCasa` conservan sus propios valores
