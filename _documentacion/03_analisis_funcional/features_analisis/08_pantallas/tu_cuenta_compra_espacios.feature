# language: es
Característica: Compra de espacios
  Como usuario
  Quiero completar el flujo de compra de espacios
  Para adquirir publicaciones o espacios disponibles

  Escenario: Selección de medio de pago y confirmación
    Dado que el usuario accede al flujo de compra
    Y selecciona un medio de pago válido
    Cuando confirma la compra
    Entonces el sistema registra la compra en la base de datos

  Escenario: Cálculo de totales por publicación
    Dado que el usuario selecciona 2 espacios
    Cuando el sistema calcula el total
    Entonces se muestran los totales actualizados
