# language: es
Característica: Sistema de Rutas y Deep Links

  Como usuario de Buscobien
  Quiero navegar entre pantallas con URLs limpias y deep links funcionales
  Para acceder directo a funcionalidades (ej. recuperación password)

  Antecedentes:
    Dado que AppRoutes define 30+ constantes de ruta (ej: "/principal", "/login", "/cambiopassword")
    Y routeGenerate es el onGenerateRoute único en MaterialApp
    Y navigatorKey global permite navegación programática

  Escenario: Navegación a ruta declarada con argumentos tipados
    Dado que el usuario navega a "/editaespacio"
    Cuando routeGenerate recibe RouteSettings con arguments: ValueEspaciosCasaGet
    Entonces el sistema castea arguments as ValueEspaciosCasaGet
    Y renderiza PaginaEditaEspacio con el objeto completo

  Escenario: Deep link recuperación password con token y perfil
    Dado que llega App Link "/recuperar?token=abc&perfil=promotor"
    Cuando deep_link_handler procesa URI
    Entonces valida token y perfil no vacíos
    Y navega via navigatorKey a AppRoutes.cambioPassword
    Con arguments {token: "abc", perfil: "promotor"}

  Escenario: Ruta sin conexión con mensaje personalizado
    Dado que checaConeccionesProvider emite "Sin conexión"
    Cuando routeGenerate resuelve "/sinconeccion"
    Entonces pasa settings.arguments as String a PaginaSinConeccion

  Escenario: Ruta desconocida retorna null (riesgo)
    Dado que el usuario navega a "/ruta-inexistente"
    Cuando routeGenerate no encuentra case匹配
    Entonces retorna null
    Y Flutter muestra pantalla en blanco (sin fallback explícito)

  Escenario: Argumentos incorrectos causan TypeError en runtime
    Dado que routeGenerate espera ValueEspaciosCasaGet para "/mapapropiedades"
    Cuando arguments es Map<String,dynamic> en lugar del tipo esperado
    Entonces el sistema lanza TypeError en cast (sin validación previa is)