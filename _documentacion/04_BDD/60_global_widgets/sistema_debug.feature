# language: es
Característica: Sistema de Debug por Niveles
  Como desarrollador
  Quiero controlar la verbosidad de los logs de depuración
  Para diagnosticar problemas sin saturar la consola

  Escenario: Activación de nivel de debug 0
    Dado que `level00` es verdadero
    Y el resto de niveles son falsos
    Cuando el sistema ejecuta `debugPrintLevels(0, "Mensaje de prueba")`
    Entonces el sistema imprime el mensaje en consola
    Y el formato es "[contador] | 0 | Mensaje de prueba"

  Escenario: Desactivación de nivel de debug 0
    Dado que `level00` es falso
    Cuando el sistema ejecuta `debugPrintLevels(0, "Mensaje de prueba")`
    Entonces el sistema no imprime nada en consola

  Escenario: Activación de nivel de debug 1 con prefijo
    Dado que `level01` es verdadero
    Cuando el sistema ejecuta `debugPrintLevels(1, "Ciclo de vida del widget")`
    Entonces el sistema imprime el mensaje en consola
    Y el formato es "[contador] | 1 | LYFECYCLE: Ciclo de vida del widget"

  Escenario: Activación de nivel de debug 5 para imágenes
    Dado que `level05` es verdadero
    Cuando el sistema ejecuta `debugPrintLevels(5, "Procesando imagen")`
    Entonces el sistema imprime el mensaje en consola
    Y el formato es "[contador] | 5 | Procesando imagen"

  Escenario: Activación de nivel de debug 10 para gestión de fotos
    Dado que `level10` es verdadero
    Cuando el sistema ejecuta `debugPrintLevels(10, "Guardando foto")`
    Entonces el sistema imprime el mensaje en consola
    Y el formato es "[contador] | 10 | Guardando foto"

  Escenario: Activación de nivel de debug 12 para plataforma
    Dado que `level12` es verdadero
    Cuando el sistema ejecuta `debugPrintLevels(12, "Detectando OS")`
    Entonces el sistema imprime el mensaje en consola
    Y el formato es "[contador] | 12 | Detectando OS"

  Escenario: Nivel de debug fuera de rango
    Dado que `level99` no existe como variable
    Cuando el sistema ejecuta `debugPrintLevels(99, "Mensaje desconocido")`
    Entonces el sistema imprime el mensaje en consola
    Y el formato es "[contador] | 99 | Mensaje desconocido"

  Escenario: Contador de llamadas incrementa
    Dado que el contador `lcwc` es 0
    Cuando el sistema ejecuta `debugPrintLevels` tres veces
    Entonces el contador incrementa a 1, 2, 3
    Y cada mensaje impreso incluye su número de secuencia
