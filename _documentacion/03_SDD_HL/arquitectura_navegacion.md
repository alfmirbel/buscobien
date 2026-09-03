# <a id="X5dc0e848448e8e9eae42eab4bef87b72f6c0518"></a>Reorganización de Menús

A continuación, se describe la reorganización de los menús de la aplicación, en donde cambian las opciones con las que cuenta, por medio de los cuales se accede a la funcionalidad desarrollada a la fecha, y en las que hay que construir todavía la funcionalidad requerida\.

## <a id="menú-inicial-y-sus-opciones"></a>Menú Inicial Actual y sus Opciones

El sistema cuenta con un Menú Inicial \(\\05\_provider\_menus\_sliver\_menu\_inicial\.dart\), con su respectivo provider \(\\05\_provider\_menus\_menu\_inicial\.dart, que se encarga de guardar el estado del menú, relativa a la opción seleccionada\)\. A continuación, se muestra la nueva lista de opciones del Menú Inicial, en el orden que aparecen \(de izquierda a derecha\)\.

- Inicio
- Propiedades
- Ubicación 
- Mi Cuenta
- Perfil

La navegación entre estas opciones, y las páginas a la que se dirigen, se encuentra en el archivo \(\\02\_principal\_screen\_sliver\_screen\_menus\_inicio\.dart\)\. Después de que se termina de ejecutar el SplashScreen, la aplicación se dirige a la primera opción del menú, “Inicio”\.

La opción de “Inicio” presenta la página de entrada a las landing pages con fichas descriptivas de los tipos de perfiles\. Cada ficha redirige a la Landing Page correspondiente al perfil \(ej\. La ficha de Promotores dirige a la Landing Page de Promotores, archivo \\03\_vistas\_promotores\.dart, excepto la opción de “Propiedades”\)\. Todas las landing pages se encuentran en el directorio \\03\_vistas\.

La opción de “Propiedades” se describe más adelante a detalle, ya que por ahora es la página que contiene la principal funcionalidad\.

## <a id="opción-propiedades-del-menú-inicial"></a>Opción “Propiedades” del Menú “Inicial”

Una de las opciones disponibles en este menú es la de “Propiedades”, que tiene como objetivo mostrar una serie de menús superior anidados, todos visibles dentro de la misma página, dejando un área para mostrar las fichas de propiedades, resultado de la buscar resultante, considerando las características combinadas de los menús que funcionan como filtros, es decir, aquellas que cumplen con los criterios de las opciones seleccionadas\. El archivo primario es \\08\_pantallas\_inicio\_busca\_espacios\.dart, y en cuyo directorio \\08\_pantallasestán los archivos que necesita para operar\.

## <a id="Xe7eb114488e7a7860385affdd62b378acea421b"></a>Tipos de opciones debajo de la opción “Propiedades”

En un segundo nivel, de los menús superiores de la página mostrada con la opción “Propiedades”, se muestra el llamado Menú Principal \(contenido en el archivo \\05\_provider\_menus\_sliver\_menu\_principal\.dart\) con su respectivo provider \(archivo \\05\_provider\_menus\_menu\_principal\.dart\)\. Este menú tiene siete opciones, correspondientes a tres grupos de funcionalidades: tipo de propiedad, la ubicación geográfica y el usuario\.

### <a id="tipo-de-propiedad"></a>1\. Tipo de Propiedad

Las Primeras cuatro opciones del Menú Propiedades, de izquierda a derecha, relacionadas con la selección del tipo de propiedades a mostrar\. Nombre de las opciones:

- “Todas”
- “Casas”
- “Departamentos”
- “Otros inmuebles”

La opción de “Otros inmuebles” tiene incluido un menú DropDown que muestra otros tipos de propiedades, ejemplo Bodegas, Terrenos, Ranchos, Lotes, etc\. \(archivo \\05\_provider\_menus\_menu\_principal\_propiedades\.dart\)\.

Estas cuatro opciones, al seleccionarlas, muestran un tercer, un cuarto y un quinto menú, que se describen más adelante\.

### <a id="ubicación-geográfica"></a>2\. Ubicación Geográfica

Otro grupo es el relacionado con la selección de la ubicación geográfica en la que se buscarán propiedades, \(relacionada con el siguiente menú que se describe para esta opción y con el menú de tercer nivel de las opciones relacionadas con las cuatro opciones anteriores, donde se muestran propiedades \(localización en la que se buscan las propiedades\)\.

La siguiente opción, “Ubicación”, permite seleccionar la ubicación geográfica en la que se buscarán las propiedades\. Esta accede a la base de datos en las que se tiene todas las opciones disponibles y se buscan por Código Postal, para lo cual se tiene la página especifica en \\08\_pantallas\_principal\_localidades\.dart, y todos los archivos relativos a esta funcionalidad de ubicación, o localidad, están en los directorios \\08\_pantallas, el cual hace uso de las funciones de los elementos contenidos en los directorios \\50\_localidades y, para el manejo de las localidades seleccionadas por un usuarios, \\12\_localidades\_user\. Nombre de la opción:

- “Ubicación”

ACCIÓN: Quita o bloquea del Menú Principal la opción “Ubicación”, y colócala reubicada en el Menú Inicial\.

### <a id="usuario"></a>3\. Usuario

Las últimas dos opciones, una que tiene que ver con la cuenta del usuario, “Mi Cuenta” \(archivos del directorio \\08\_pantallas\_cuenta , opción que desplegará opciones dependiendo de su perfil, que para promotores inicia con la página \\08\_pantallas\_cuenta\_espacios\_tus\_espacios\.dart, para los otros perfiles no está implementada la funcionalidad de cada uno\), y la última opción del menú __“__Propiedades”, está diseñada para mostrar los datos del usuario, mismos que componen su “Perfil” \(archivo \\08\_pantallas\_perfil\.dart\)\.

- “Mi Cuenta”
- “Perfil”

ACCIÓN: Quita o bloquea del Menú Principal la opción “Mi Cuenta”, y colócala reubicada en el Menú Inicial\.

ACCIÓN: Quita o bloquea del Menú Principal la opción “Perfil”, y colócala reubicada en el Menú Inicial\.

## <a id="mis-espacios-opción-para-promotores"></a>Navegación de la Aplicación

El estado de todos lo menús se lleva a cabo, por medio de los providers de los mismos, en los archivos \\01\_home\_navigation\_provider\.dart y \\01\_home\_navigation\_provider\.g\.dart, dentro del cual se define una variable global para cada menú:

- void setInicial\(int i\) => state = state\.copyWith\(indiceInicial: i\);
- void setPrincipal\(int i\) => state = state\.copyWith\(indicePrincipal: i\);
- void setGobierno\(int i\) => state = state\.copyWith\(indiceNivelGobierno: i\);
- void setEspacio\(int i\) => state = state\.copyWith\(indiceTipoEspacio: i\);
- void setTransaccion\(int i\) =>
- state = state\.copyWith\(indiceTipoTransaccion: i\);
- void setMiCuenta\(int i\) => state = state\.copyWith\(indiceMiCuenta: i\);
- void setMiCuentaUsuario\(int i\) =>
- state = state\.copyWith\(indiceMiCuentaUsuario: i\);

Mediante estas variables se conoce la opción seleccionada activa de cada menú, y se actualizan de manera dinámica\.

ACCIÓN: Actualiza la navegación de todos lo menús, con las nuevas opciones\.

# Genera la instrucción para Antigravity para que lleve a cabo la reorganización del Menu Inicial y del Menú Principal, de acuerdo con el siguiente documento:

Aquí tienes la instrucción técnica, estructurada y directa para que Antigravity ejecute la reorganización de los menús sin ambigüedades\. Puedes copiar y pegar el siguiente bloque directamente al agente:

__Instrucción para Antigravity: __

__Reorganización de Menús \(Inicial y Principal\)__

__Objetivo:__ Refactorizar la estructura de navegación y estado de los menús de la aplicación, trasladando opciones del "Menú Principal" al "Menú Inicial" y eliminando opciones obsoletas del "Menú Inicial", actualizando simultáneamente los índices de navegación en los providers de Riverpod\.

__Fase 1: Refactorización del "Menú Inicial"__

- __Archivos objetivo:__ \\05\_provider\_menus\_sliver\_menu\_inicial\.dart y \\05\_provider\_menus\_menu\_inicial\.dart\.
- __Acción:__ Eliminar o comentar estrictamente las opciones: "Particulares", "Promotores", "Tienda", "Productos", "Servicios", "Asociaciones" e "Inmobiliarias"\.
- __Acción:__ Incorporar las opciones trasladadas desde el Menú Principal\.
- __Estado Final Esperado \(de izquierda a derecha, índices 0 al 4\):__
	1. Inicio
	2. Propiedades
	3. Ubicación
	4. Mi Cuenta
	5. Perfil

__Fase 2: Refactorización del "Menú Principal" \(Submenú de Propiedades\)__

- __Archivos objetivo:__ \\05\_provider\_menus\_sliver\_menu\_principal\.dart y \\05\_provider\_menus\_menu\_principal\.dart\.
- __Acción:__ Eliminar de este menú las opciones: "Ubicación", "Mi Cuenta" y "Perfil" \(ya que han sido movidas al Menú Inicial\)\.
- __Estado Final Esperado \(de izquierda a derecha, índices 0 al 3\):__
	1. Todas
	2. Casas
	3. Departamentos
	4. Otros inmuebles \(Manteniendo su DropDown en \\05\_provider\_menus\_menu\_principal\_propiedades\.dart\)\.

__Fase 3: Actualización de Enrutamiento de Pantallas__

- __Archivo objetivo:__ \\02\_principal\_screen\_sliver\_screen\_menus\_inicio\.dart\.
- __Acción:__ Mapear los nuevos índices del __Menú Inicial__ hacia sus pantallas correspondientes:
	- Índice Ubicación \-> Renderizar el flujo de \\08\_pantallas\_principal\_localidades\.dart\.
	- Índice Mi Cuenta \-> Renderizar el flujo del directorio \\08\_pantallas\_cuenta \(iniciando en \\08\_pantallas\_cuenta\_espacios\_tus\_espacios\.dart para promotores\)\.
	- Índice Perfil \-> Renderizar \\08\_pantallas\_perfil\.dart\.

__Fase 4: Actualización del Gestor de Estado de Navegación__

- __Archivos objetivo:__ \\01\_home\_navigation\_provider\.dart y su archivo generado \\01\_home\_navigation\_provider\.g\.dart\.
- __Acción:__ Actualizar la lógica de setInicial\(int i\) y setPrincipal\(int i\) para que reflejen la nueva cantidad de índices\.
- __Acción:__ Asegurar que cuando el usuario seleccione "Ubicación", "Mi Cuenta" o "Perfil" en el Menú Inicial, las variables de estado \(indiceInicial, indiceMiCuenta, etc\.\) se actualicen correctamente sin intentar abrir los submenús de "Propiedades" que ya no les corresponden\. Re\-ejecutar build\_runner para actualizar los archivos \.g\.dart\.

__Restricciones:__ 

No cambies los nombres de los archivos ni de las variables de estado \(indiceInicial, indicePrincipal, etc\.\)\. Asegúrate de que el SplashScreen siga redirigiendo al índice 0 \("Inicio"\) del Menú Inicial por defecto\.

La opción Inicio seguirá teniendo la misma funcionalidad para llamar a las landogn pages\.

Las opciones que se reubican seguirán conteniendo las mismas opciones, con la misma funcionalidad\.

El archivo \\buscobien\\\_documentacion\\arquitectura\_navegacion\.md contiene la descripción de la organización de los menús\.

# EJECUCIÓN

__Update Todos__

- Fase 1: Refactorizar provider\_menu\_inicial\.dart \(5 opciones: Inicio, Propiedades, Ubicación, Mi Cuenta, Perfil\)
- Fase 2: Refactorizar provider\_menu\_principal\.dart \(4 opciones: Todas, Casas, Departamentos, Otros inmuebles\)
- Fase 3: Actualizar enrutamiento en principal\_sliver\_screen\_menus\_inicio\.dart
- Fase 4: Verificar home\_navigation\_provider\.dart y ejecutar build\_runner

Las 4 fases están completas\. Resumen de cambios:

__Fase 1 — __[__provider\_menu\_inicial\.dart__](vscode-webview://19d2d4pfd0qu50q4kgda2hr3cprcg5ek3c72qqlkutl6kcrisrp2/lib/05_provider_menus/provider_menu_inicial.dart)

- elementosMenuInicial reducido de 10 a 5 items: iconoInicio, iconoVerPropiedades, iconoUbicacion, iconoTuCuenta, iconoPerfil
- buttonSelectOpcion reducido de 10 a 5 bools
- Bloque de reset en asignaNuevaOpcionSeleccionada ajustado a 5 entradas

__Fase 2 — __[__provider\_menu\_principal\.dart__](vscode-webview://19d2d4pfd0qu50q4kgda2hr3cprcg5ek3c72qqlkutl6kcrisrp2/lib/05_provider_menus/provider_menu_principal.dart)

- elementosMenuPrincipal reducido de 7 a 4 items: iconoTodasPropiedades, iconoCasas, iconoDepartamentos, iconoOtrosInmuebles \(sin Ubicación, Mi Cuenta ni Perfil\)
- buttonSelectOpcion reducido de 7 a 4 bools

__Fase 3 — __[__principal\_sliver\_screen\_menus\_inicio\.dart__](vscode-webview://19d2d4pfd0qu50q4kgda2hr3cprcg5ek3c72qqlkutl6kcrisrp2/lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart)

- Enrutamiento reestructurado: indiceInicial 2→Ubicación, 3→Mi Cuenta, 4→Perfil \(antes estaban como sub\-casos de indicePrincipal 4, 5, 6\)
- El menuSuperiorMenuPrincipal solo se muestra cuando indiceInicial == 1 \(Propiedades\)
- Eliminado el caso de landing pages vía tabs \(índices 2–9\), que ya no aplica
- Import 00\_principales\_opciones\.dart eliminado \(quedó sin uso\)

__Fase 4 — home\_navigation\_provider\.dart__ sin cambios de código \(los setters son genéricos y correctos\); build\_runner ejecutado y generó 158 outputs sin errores\.

Principio del formulario

Final del formulario

