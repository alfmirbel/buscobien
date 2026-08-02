# Motor Social

Para la funcionalidad del Motor Social, el diseño debe ser el siguiente:

Al seleccionar la opción “Mi cuenta” del Menú Principal, mostrado al seleccionar la opción “Propiedades” del Menú Inicial, se presenta una página, que puede variar dependiendo de varias condiciones. La pantalla por mostrar, y las condiciones de que mostrar, están contenidas en el archivo \02\_principal\_screen\principal\_sliver\_screen\_menus\_inicio.dart.

- Si al seleccionar la opción no hay usuario activo en la aplicación, se muestra una pantalla en la que se invita al Usuario anónimo que está navegando a ingresar en la aplicación (o en su caso registrarse como usuario), por medio de un botón que abrirá la pantalla de logIn de la aplicación.
- Si es la primera vez que se selecciona la opción, se muestra un AVISO IMPORTANTE, de que la aplicación está en un ambiente de prueba y con fines de demostración (archivo \10\_user\_login\usuario\_login\login\_03\_form\_register\_user.dart).
- La pantalla de logIn de la aplicación es invocada por medio de un DialogBox (archivo \10\_user\_login\usuario\_login\dialogbox\_login.dart).
- En caso de que el usuario seleccione Registrase, se invoca a la página contenida en el archivo \10\_user\_login\usuario\_login\login\_03\_form\_register\_user.dart.
- Si ya hay un usuario que ha ingresado a la aplicación, con un nombre de usuario y una clave de acceso validas, dependiendo del perfil muestra información, tal como se establece en el Mapa de Arquitectura y Referencia Técnica, en el apartado Opción “Mi Cuenta”, para los perfiles de Usuario y Promotor.
- En este documento de Arquitectura se establece que todos los perfiles contarán con las tres opciones del motor social: Mis Listas, Mis Grupos y Mis conocidos.
