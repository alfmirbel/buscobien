# Inventario de seguridad de las bases de CouchDB (S4)

**Creado:** 2026-10-17 a partir de un recorrido de solo lectura del servidor de desarrollo (`~/seguridad/inventario.sh`: solo nombres de campos, tipos, conteos y permisos; ningún valor de documentos) y del código de `lib/`.  
**Uso:** base de la fase S4 de [`plan_seguridad_nginx_jwt.md`](../08_operacion_guias_y_despliegue/plan_seguridad_nginx_jwt.md): qué permisos fijar en cada base y qué regla de escritura aplicar.  
**Estado:** inventario terminado; **no se ha cambiado ningún permiso** (salvo las 4 bases de la cuenta de servicio, ya hechas en el paso A).

## 1. Hallazgos principales

1. **Todas las bases están hoy en modo «solo administrador»** (`members.roles = ["_admin"]`; es el valor predeterminado de CouchDB 3). Un usuario con JWT recibe `403` en cualquier base hasta que se le conceda acceso. S4 consiste en **abrir lo mínimo necesario**, no en cerrar.
2. **El servidor comparte CouchDB con otros proyectos** (`citigov_*`, `comosano_*`, `motorsocial_*`, `teicausuarios`, `folios`, `inesecciones`: 22 bases). La credencial de administrador que lleva la app abre también esas bases. No se tocan en S4; el cierre del acceso de administrador (S5) las protege a todas.
3. **El identificador de propietario coincide con el del JWT** (`sub = usuario.id_usuario`, 64 hex) en todas las bases con campo de propietario: en la muestra, los valores de `espacioscasa.idusuario`, `senderId`, `usuarioId`, `userId`, `idUsuario`, `creadorId`, etc. corresponden a identificadores de usuarios reales (`receiverId` en mensajes también contiene identificadores de grupo o listas). Una regla `validate_doc_update` por propietario es viable.
4. **CouchDB no puede proteger la lectura por documento.** Las bases con datos privados entre personas (chat, invitaciones, listas, ubicación del domicilio, compras) quedarían legibles por cualquier usuario con sesión si se abren por rol. Ver la decisión D7 (sección 5).
5. **El código usa 3 bases que no existen** en el servidor: `buscobien_propiedades`, `buscobien_espacios` y `buscobien_propiedades_compartidas_conocidos`. Hoy esas llamadas devuelven 404 (listas con detalle de propiedad, perfil de contacto, **burbujas de propiedad del chat** de MEJ-31 y el detalle de grupo). Es un defecto funcional independiente de la seguridad (sección 4).
6. **`buscobien_compra_espacios` la escribe el cliente** (total, impuestos, referencia de pago). Un cliente modificado podría registrar compras con importes falsos; el registro de pagos debe hacerse en el servidor.
7. **Fuga de datos actual en las vistas de usuarios:** `DDUSER/vistaNOMBRE` emite el documento completo (con el hash). Hoy solo la leen el administrador y `buscobien_api`; se retira con el cambio C5 de la app.

## 2. Clasificación y reglas por base

**Propietario** = campo cuyo valor debe ser igual a `userCtx.name` (el `sub` del JWT) para poder escribir.  
**Lectura** indica quién puede leer si se abre la base por rol; el acceso anónimo solo se necesita donde se indica.

### 2.1 Referencia pública (solo lectura para todos)

| Base | Docs | Propietario | Lectura | Escritura | Acción S4 |
| :--- | ---: | :--- | :--- | :--- | :--- |
| `codigospostales` | 145.911 | — | **Pública (también sin sesión**: el registro consulta el CP antes de iniciar sesión) | Nadie salvo administrador | `members` abierto + `validate_doc_update` que rechaza todo salvo `_admin` |
| `localidadesinegi` | 299.576 | — | Pública | Nadie salvo administrador | Igual |

### 2.2 Catálogo y medios (lectura pública, escritura del propietario)

| Base | Docs | Campo de propietario | Lectura | Escritura | Regla `validate_doc_update` |
| :--- | ---: | :--- | :--- | :--- | :--- |
| `buscobien_publicados_{normal,destacado,super,oportunidad,remate}` (5) | 30–34 c/u | `espacioscasa.idusuario` | Pública (feed de propiedades; **pendiente D8**: con o sin sesión) | Propietario: publicar, editar, despublicar | `idusuario` del documento nuevo y del anterior = `userCtx.name`. Nota: los *design docs* de estas bases son 26 (vistas y conteos); solo escribe el administrador |
| `buscobien_propiedades_casas_fotos` | 771 (47 MB) | `fotosCasa.idUsuario` | Pública | Propietario | Igual con `fotosCasa.idUsuario` |
| `buscobien_fotos_ordenadas` | 16 | `listadefotos.idUsuario` | Pública | Propietario | Igual con `listadefotos.idUsuario` |
| `buscobien_avatares` | 3 | `idUsuario` | Cualquier usuario con sesión | Solo el propio usuario | Igual con `idUsuario` |

### 2.3 Datos del propietario (sensibles; lectura debería ser solo del dueño)

| Base | Docs | Campo de propietario | Qué contiene | Escritura | Observación |
| :--- | ---: | :--- | :--- | :--- | :--- |
| `buscobien_casas_comprados_{normal,destacado,super,oportunidad,remate}` (5) | 31–46 | `espacioscasa.idusuario` | Inmuebles del promotor (borradores y publicados) con datos de contacto | Propietario | Lectura privada deseable; el cliente las consulta por `DDUSER/idUser` |
| `buscobien_user_localidad` | 10 | `id_usuario` | **Domicilio y coordenadas del usuario** | Propietario | Sensible |
| `buscobien_compra_espacios` | 6 | `idUsuario` | **Compras, importes y referencias de pago** | Hoy el cliente; **debe pasar al servidor** | Sensible y manipulable (hallazgo 6) |
| `buscobien_listas_propiedades` | 28 | `listapropiedad.userId` | Listas de propiedades guardadas | Propietario | Privada |
| `buscobien_usuarios_listas` | 10 | `userId` | Nombres de las listas | Propietario | Privada |
| `buscobien_megusta_propiedades` | 8 | `usuarioId` | «Me gusta» | Propietario | Privada |

### 2.4 Red social (participantes concretos; **lectura no protegible por CouchDB**)

| Base | Docs | Campos de participantes | Escritura legítima | Regla de escritura propuesta |
| :--- | ---: | :--- | :--- | :--- |
| `buscobien_mensajes` | 31 | `senderId`, `receiverId` | El remitente crea; nadie edita (salvo marcar leído el destinatario) | Crear: `senderId = userCtx.name`; actualizar: solo el campo de lectura y solo el destinatario |
| `buscobien_invitaciones` | 10 | `senderId`, `receiverId` | El remitente crea; el destinatario cambia `status`; cualquiera de los dos borra al eliminar el contacto | Crear: `senderId = name`; actualizar: `receiverId = name` y solo `status`; borrar: remitente o destinatario |
| `buscobien_listas_compartidas_usuarios` | 6 | `usuarioOrigenId`, `usuarioDestinoId` | El origen crea y borra | Crear/borrar: `usuarioOrigenId = name` |
| `buscobien_listas_prop_compartidas` | 6 | **ninguno** (solo `listaCompartidaId`) | Se agregan propiedades a una lista compartida | **No se puede validar al propietario sin leer otra base** → candidata a endpoint |
| `buscobien_grupos` | 4 | `creadorId`, `miembros[].usuarioId` | Crea el creador; entran miembros (propios) y el administrador expulsa | Complejo: ver nota |
| `buscobien_grupos_invitaciones` | 4 | `senderId`, `receiverId` | Igual que invitaciones | Igual que invitaciones |
| `buscobien_grupos_mensajes` | 9 | `senderId` (el grupo en `grupoId`) | Miembros del grupo | `senderId = name`; **pertenecer al grupo no se puede comprobar** |
| `buscobien_grupos_avisos` | 2 | `autorId` | Administradores del grupo | `autorId = name`; el rol de administrador no se puede comprobar |
| `buscobien_grupos_publicaciones` | 1 | no se pudo determinar (sin documentos de muestra) | Miembros | Revisar el modelo antes de decidir |
| `buscobien_social` | 2 | `senderId`, `receiverId` (vacíos) | **Sin uso aparente**: restos del primer motor social (tipos `invitation`/`chat_message`) | Cerrar; confirmar en el código antes de borrar |

*Nota sobre `buscobien_grupos`:* entrar a un grupo público modifica un documento cuyo `creadorId` es otro usuario. La regla debe permitir que un usuario añada o quite **solo su propia** entrada en `miembros[]`, y que los administradores del grupo editen lo demás; es la regla más compleja de S4 y la menos fiable de mantener en una función de validación.

### 2.5 Bases de la cuenta de servicio (ya hechas en el paso A)

| Base | Docs | Estado |
| :--- | ---: | :--- |
| `buscobien_usuarios` | 6 | `members.names = ["buscobien_api"]` |
| `buscobien_usuarios_promotores` | 7 | Igual |
| `buscobien_usuarios_propietarios` | 4 | Igual |
| `buscobien_sesiones` | 2 | Igual |

### 2.6 Otros proyectos en el mismo CouchDB (no se tocan)

`citigov_grupos`, `citigov_problemas`, `citigov_publicaciones`, `citigov_user_localidad`, `citigov_usuarios`, `comosano_alimentos`, `comosano_log_calorias`, `comosano_perfil_nutricional`, `comosano_usuarios`, `folios`, `inesecciones`, `motorsocial_*` (10 bases), `teicausuarios`.

## 3. Cuántas bases quedan en cada caso

| Grupo | Bases | Qué se puede hacer con permisos + `validate_doc_update` |
| :--- | ---: | :--- |
| Referencia pública | 2 | Todo |
| Catálogo y medios | 8 | Todo (lectura abierta, escritura del propietario) |
| Datos del propietario | 10 | La **escritura** sí; la **lectura** queda abierta a los usuarios con sesión |
| Red social | 10 | La escritura parcialmente; la **lectura de datos privados no** |
| Cuenta de servicio | 4 | Ya cerradas |

## 4. Defectos descubiertos (para el plan de mejoras)

| ID propuesto | Defecto | Dónde | Efecto |
| :--- | :--- | :--- | :--- |
| H-34 | Consultas a bases inexistentes `buscobien_propiedades` | `provider_listas_propiedades.dart:309`, `provider_user_lists.dart:240`, `page_perfil_contacto.dart:15` | Las listas no muestran el detalle de la propiedad y el perfil de contacto no encuentra sus propiedades |
| H-35 | Consultas a la base inexistente `buscobien_espacios` | `burbujas_chat.dart:78` (MEJ-31), `page_detalle_grupo.dart:603` | Las burbujas de propiedad en el chat privado y de grupo no cargan datos. Las propiedades están repartidas en `publicados_*` y `casas_comprados_*` según el tipo de anuncio |
| H-36 | `buscobien_propiedades_compartidas_conocidos` no existe | `provider_propiedades_compartidas_conocidos.dart` | Compartir propiedades con un conocido falla |
| H-37 | Compras escritas por el cliente | `provider_compra_espacios.dart` | Importes y referencia de pago manipulables |
| H-38 | `buscobien_social` sin uso | `social_providers.dart` (restos) | Datos y código duplicados del motor social |

Las bases de propiedades dependen de `tipodeespacio` (normal, destacado, super, oportunidad, remate) para localizar un inmueble por su id; los mensajes de chat solo guardan `propiedadId`, por lo que la corrección de H-35 requiere buscar el inmueble en las cinco bases `publicados_*` (o guardar el tipo en el mensaje).

## 5. Decisiones que necesito

| ID | Decisión | Opciones | Recomendación |
| :--- | :--- | :--- | :--- |
| D7 | **Bases con datos privados entre personas** (20 bases de los grupos 2.3 y 2.4) | **A)** Abrirlas a los usuarios con sesión con la regla de escritura por propietario y **aceptar** que cualquier usuario autenticado puede leerlas con una consulta propia (riesgo documentado, válido para desarrollo). **B)** Mantenerlas cerradas y servirlas desde `buscobien-api` (endpoints por funcionalidad; el chat en vivo necesita un canal de eventos propio). **C)** Mixto: A para catálogo y datos de propietario; B para `mensajes`, `grupos_mensajes`, `user_localidad` y `compra_espacios` (los más sensibles) | **C**. Reduce el riesgo donde duele sin parar la app: primero `compra_espacios` (también corrige H-37), `user_localidad` y los mensajes privados |
| D8 | **¿Se debe ver el catálogo sin iniciar sesión?** | Sí (visitante anónimo) / No | Si es sí: `publicados_*`, fotos y referencias con `members` abierto (anónimo) y escritura bloqueada por la regla; si es no: rol de usuario |
| D9 | **Bases inexistentes en el código** | Corregir el código para usar `publicados_*`/`casas_comprados_*` / crear las bases que faltan | Corregir el código (H-34 a H-36) dentro de los cambios C de la app |
| D10 | **`buscobien_social`** | Borrar tras respaldo / dejar | Respaldar y cerrar; borrar cuando se confirme que ningún código la usa |

## 6. Orden propuesto para S4 una vez resueltas D7–D10

1. Referencia pública (`codigospostales`, `localidadesinegi`): permisos abiertos + regla «solo administrador escribe».
2. Catálogo y medios: permisos + regla de propietario; probar con una cuenta de prueba y la matriz (lectura con/sin token; escritura propia/ajena).
3. Datos del propietario y red social según D7.
4. Subir las reglas y los *design documents* al repositorio (`db/design/`), con las reglas generadas desde esta tabla.
5. Pruebas automáticas de la matriz en `buscobien-api/scripts/` (contra la CouchDB de pruebas).
