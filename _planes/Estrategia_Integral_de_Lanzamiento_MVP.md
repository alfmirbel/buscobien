# Estrategia Integral de Lanzamiento MVP

## 1\. Definición y Alcance del MVP 

El MVP de Buscobien está diseñado bajo un enfoque de desarrollo ágil y escalable\. El alcance se concentra estrictamente en resolver el problema central: conectar a promotores y compradores, eliminando la fricción operativa\.

- __Funciones Clave Incluidas \(Versión 1\.0\):__ Publicación de Propiedades \(inventario inicial\), Buscador Parametrizado \(filtros avanzados\) y Contacto Directo \(redirección a WhatsApp/correo\)\.
- __Características Excluidas \(Versión 2\.0\+\):__ Gestión avanzada de proyectos, foros interactivos, agendas automatizadas y herramientas nativas de marketing digital\.

## 2\. Modelo de Monetización "Paga lo que Usas" 

Se elimina el secuestro financiero de membresías obligatorias, migrando a un esquema de consumo bajo demanda con caducidad automática a los 30 días\.

- __Almacenamiento Base Gratuito \($0\):__ El promotor mantiene su inventario en "Cartera" en la base de datos \(CouchDB\) como un CRM personal sin costo\. Limitado a tres fotos por propiedad\.
- __Compra de Espacios de Publicación:__ Al comprar un Espacio, se tiene un espacio previo a la publicación, en donde se podrá transferir de “Mi Cartera” a los espacios comprados, “Mis Espacios”\. Al comprar un anuncio, se activa la carga de hasta 60 fotos, con el switch de publicación\.
- __Switch de Publicación y Renovación Automática:__ al activar el switch de publicación en “Mis Espacios”, se transfiere a los espacios publicados “Mis Publicaciones” y este se publica hasta que se desactiva la publicación los espacios comprados\.
- __Aviso de Depuración Proactivo:__ 3 días antes del corte, el backend \(Node\.js\) avisa al usuario los espacios activos en “Mis Espacios y en “Mis Publicaciones”, con el costo para el siguiente mes, de acuerdo con las tarifas por espacios no publicado y a las propiedades publicadas\. Si el inmueble se vendió, el promotor apaga el switch \(interfaz MD3\)\. Si no, el sistema ejecuta el cobro vía Stripe\.

## 3\. Estrategia de Adquisición: "Socio Fundador" 

Modificar la aplicación para que el usuario pueda contar con un Catálogo de propiedades \(Opción “Mi Catálogo”\), que podrá cargar con “Mi Asistente IA”, dentro del menú principal de la opción “Mi cuenta\. 

El menú de “Mi cuenta” tendrá las siguientes opciones: 

- “Mi Catálogo”, catálogo de todas su cartera de propiedades, limitado a tres fotografías por propiedad, sin costo\. Cuenta con la funcionalidad de dar altas, bajas y cambios\.
- “Mis Espacios”, con los espacios comprados, sin límite de carga de fotos, con opción a publicar, o dejar de publicar, propiedades\. Cuenta con la opción de comprar el espacio, modificar los datos de la propiedad \(captura de propiedades\) y eliminación del espacio comprado\.
- “Mis Publicaciones”, muestra las propiedades que han sido publicadas desde la opción “Mis Espacios”, las propiedades se dejan de publicar desde la opción “Mis Espacios”\.
- “Mis Listas”, con las listas de propiedades\.
- “Mis Grupos”, grupos de usuarios o promotores a los que pertenece el usuario o promotor, a los que se incorporó por invitación o solicitud de incorporación\.
- “Mis Conocidos”, con usuarios o promotores con los que ya estableció vinculo a través de invitaciones, o solicitud de información \(caso usuario – promotor\)\.

La aplicación deberá contar con un botón para transferir propiedades del catálogo “Mi Catálogo”, a los espacios comprados, “Mis Espacios”\. 

La ficha de los espacios comprados \(“Mis Espacios”\) cuenta con un botón para publicar, con o que se debe transferir las propiedades al catálogo de “Mis Publicaciones”\. Las propiedades en el catalogo de “Mis Publicaciones se borran desde el catalogo QMis Espacios”, por medio de la opción \(botón\) “Dejar de Publicar”\.

__Ola 1 \(Primeros Usuarios registrándose en el primer mes\):__

- 6 meses al 100% de bonificación \(2 Sobresalientes, 5 Relevantes, 20 Normales, 5 anuncios de Oportunidades y 20 anuncios de Remates\)\. *Condición:* Publicar al menos 3 propiedades reales en sus primeros 15 días\.

__Ola 2 \(Siguientes Usuarios registrándose en el segundo mes\):__

- Beneficio reducido a 4 meses al 100% de bonificación \(2 Sobresalientes, 5 Relevantes, 20 Normales\. 5 anuncios de Oportunidades y 20 anuncios de Remates\), cerrando la ventana 2 meses después del lanzamiento comercial\. *Condición:* Publicar al menos 3 propiedades reales en sus primeros 15 días\.

__Ola 3 \(Siguientes Usuarios registrándose en el tercer mes\):__

- Beneficio reducido a 2 meses al 100% de bonificación \(2 Sobresalientes, 5 Relevantes, 20 Normales, 5 anuncios de Oportunidades y 20 anuncios de Remates\), cerrando la ventana 3 meses después del lanzamiento comercial\.

Agotados los meses bonificados a los primeros usuarios, se aplican los precios establecidos para cada anuncio\.

En caso de que el promotor no publique propiedades en los primeros 15 días, pierde la promoción\.

### Promoción para usuarios registrados

El usuario registrado tendrá derecho a publicar únicamente un anuncio Normal de forma gratuita\. Podrá cambiar su anuncio a Sobresalientes, o Relevantes, pagando el costo de estos tipos de anuncios\.

## 4\. Arquitectura de Operaciones, Confianza y Riesgos

__Servicio de Conserjería \(Fricción Cero\):__ 

- Se habilita una función con apoyo de IA, para que rellenen los anuncios, a partir de fichas PDF o Word \(a través de Hermes Real Estate Plan\)\.

__Seguridad Manual \(MVP\):__ 

- Se solicita INE y Constancia de Situación Fiscal durante la Conserjería\.

__Infraestructura:__ 

- Frontend en Flutter interactuando con backend Node\.js/CouchDB, utilizando Stripe para pagos y almacenamiento seguro de tarjetas\.

## 5\. Estrategia de precios

Costos con la idea de tener un esquema de costos de "paga lo que usas" o "paga solo lo que necesitas”:

__Tipo de Anuncio__

__Costo de espacio sin publicar \(por 30 días\)__

__Costo de espacio publicado \(por 30 días\)__

Sobresaliente

$225\.00

$900\.00

Relevante

$125\.00

$500\.00

Normal

$50\.00

$200\.00

Oportunidades

$50\.00

$200\.00

Remates

$50\.00

$200\.00

El costo se cobra a finales de mes, en la parte proporciona de los días que tuvo el espacio contratado o el anuncio publicado\. y se cobra a finales de mes calendario\.

