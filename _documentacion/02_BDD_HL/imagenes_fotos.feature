# language: es
Característica: Gestión de imágenes y fotos de propiedad
  Como propietario o agente
  Quiero agregar, comprimir y organizar fotos
  Para presentar propiedades con material visual

  Escenario: Agregar múltiples fotos a una propiedad
    Dado que el usuario está capturando fotos para una propiedad
    Cuando selecciona y confirma 5 imágenes
    Entonces el sistema comprime las imágenes
    Y las asocia a la propiedad

  Escenario: Gestión de avatar
    Dado que el usuario accede a “Gestionar avatar”
    Cuando selecciona una imagen y confirma
    Entonces el sistema sube el avatar
    Y lo muestra en pantalla de perfil
