# language: es
Característica: Tus espacios: CRUD y compra de propiedades
  Como propietario o agente
  Quiero publicar, editar y comprar espacios
  Para administrar mis propiedades publicadas

  Escenario: Listado de espacios publicados
    Dado que el usuario tiene propiedades publicadas
    Cuando abre "Tus espacios"
    Entonces el sistema lista sus propiedades y fotos asociadas

  Escenario: Creación y edición condicional
    Dado que el usuario crea una propiedad
    Y selecciona "Casa" o "Departamento"
    Cuando completa y guarda el formulario
    Entonces el sistema presenta u oculta campos condicionales según el tipo elegido

  Escenario: Publicar o despublicar propiedad
    Dado que el usuario edita una propiedad existente
    Cuando cambia el estado de publicación
    Entonces el sistema persiste el cambio en la base de datos
