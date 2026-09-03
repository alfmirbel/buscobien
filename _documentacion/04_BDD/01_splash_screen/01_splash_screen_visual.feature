# language: es
Característica: Visualización del Splash Screen
  Como usuario final
  Quiero ver la pantalla de bienvenida con la identidad visual de BuscoBien
  Para reconocer la marca mientras la aplicación se inicializa

  Escenario: El splash screen muestra todos los elementos visuales al iniciar la app
    Dado que el usuario acaba de abrir la aplicación
    Cuando el splash screen se renderiza por primera vez
    Entonces el sistema debe mostrar un fondo con degradado oscuro
    Y el sistema debe mostrar el logo de BuscoBien en blanco
    Y el sistema debe mostrar el nombre de la aplicación en blanco
    Y el sistema debe mostrar el texto de bienvenida "Bienvenido al mejor lugar de Bienes Raíces para encontrar el espacio que necesitas"
    Y el sistema debe mostrar un indicador de carga circular blanco en movimiento
    Y el sistema debe mostrar la etiqueta "SITIO DE PRUEBAS Y DEMO" en la parte inferior
    Y el sistema debe mostrar el número de versión actual en la esquina inferior derecha
    Y todos los elementos visuales deben permanecer estáticos hasta que finalice el temporizador

  Escenario: Diseño responsivo en pantallas pequeñas
    Dado que el usuario abre la aplicación en un dispositivo con pantalla angosta
    Cuando el splash screen calcula las dimensiones de los elementos flotantes
    Entonces el sistema debe escalar las figuras de fondo a un 75% de su tamaño original
    Y el sistema debe mantener legibles los textos superpuestos
    Y el sistema no debe recortar el contenedor de glassmorphism central

  Escenario: Efecto glassmorphism en el contenedor central
    Dado que el usuario observa el splash screen
    Cuando el contenedor central se renderiza
    Entonces el sistema debe aplicar un desenfoque (blur) sobre las imágenes de fondo
    Y el sistema debe mostrar un relleno blanco semitransparente
    Y el sistema debe mostrar un borde blanco semitransparente alrededor del contenedor
    Y las imágenes de fondo deben estar atenuadas con una capa negra al 30% de opacidad
